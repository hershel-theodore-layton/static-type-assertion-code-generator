/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

use namespace HH;
use namespace HH\Lib\{C, Str};
use type HTL\StaticTypeAssertionCodegen\_Private\{
  ArraykeyTypeDescription,
  BoolTypeDescription,
  CallThisUserSuppliedFunction,
  DictTypeDescription,
  FloatTypeDescription,
  IntTypeDescription,
  KeysetTypeDescription,
  MixedTypeDescription,
  NonnullTypeDescription,
  NullTypeDescription,
  NullableTypeDescription,
  NumTypeDescription,
  ShapeField,
  ShapeTypeDescription,
  StringTypeDescription,
  TupleTypeDescription,
  TypeDescription,
  VecOrDictTypeDescription,
  VecTypeDescription,
};
use type HTL\TypeVisitor\{TAlias, TypeDeclVisitor};
use type ReflectionException, ReflectionTypeAlias;
use function var_export_pure;

final class DefaultVisitor
  implements TypeDeclVisitor<TypeDescription, ShapeField> {

  public function __construct(
    private dict<string, string> $typeAliasAsserters,
    private (function(string)[]: nothing) $panic,
    private (function(?string, arraykey)[]: ?string) $shapeFieldNameResolver,
    private shape(?'closed_shape_suffix' => string /*_*/) $options = shape(),
  )[] {}

  public function panic(string $message)[]: nothing {
    return ($this->panic)($message);
  }

  public function unsupportedType(string $message)[]: nothing {
    return ($this->panic)($message);
  }

  public function shapeField(
    ?string $parent_shape_name,
    arraykey $key,
    bool $is_class_constant,
    bool $is_optional,
    TypeDescription $type,
  )[]: ShapeField {
    $repr = ($this->shapeFieldNameResolver)($parent_shape_name, $key);

    if ($repr is null && $is_class_constant) {
      return $this->panic(
        'Shapes with class constant keys can not be codegenned'.
        ' without a class constant to use in the source.',
      );
    }

    if ($repr is null) {
      if (!$key is string) {
        return $this->panic(
          'Shapes with integer keys can not be codegenned'.
          ' without a class constant to use in the source.',
        );
      }

      $repr = var_export_pure($key) as string;
    }

    return new ShapeField($key, $repr, $is_optional, $type);
  }

  public function arraykey(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ??
      new ArraykeyTypeDescription($alias['counter']);
  }

  public function bool(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new BoolTypeDescription($alias['counter']);
  }

  public function class(
    TAlias $alias,
    string $classname,
    vec<mixed> $_generics,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      $this->resolveAlias(
        shape(
          'alias' => $classname,
          'counter' => $alias['counter'],
          'opaque' => $alias['opaque'],
        ),
        false,
      ) ??
      $this->unsupportedType('class');
  }

  public function dict(
    TAlias $alias,
    TypeDescription $key,
    TypeDescription $value,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new DictTypeDescription($alias['counter'], $key, $value);
  }

  public function dynamic(TAlias $alias)[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? $this->unsupportedType('dynamic');
  }

  public function enum(TAlias $alias, string $classname)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ??
      $this->resolveAlias(
        shape(
          'alias' => $classname,
          'counter' => $alias['counter'],
          'opaque' => $alias['opaque'],
        ),
        true,
      ) ??
      $this->panic(Str\format(
        'Support for enums must be added using a $type_alias_asserters entry, got %s'.
        'See the README to learn why.',
        $classname,
      ));
  }

  public function float(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new FloatTypeDescription($alias['counter']);
  }

  public function int(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ??
      new IntTypeDescription($alias['counter']);
  }

  public function interface(
    TAlias $alias,
    string $classname,
    vec<mixed> $_generics,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      $this->resolveAlias(
        shape(
          'alias' => $classname,
          'counter' => $alias['counter'],
          'opaque' => $alias['opaque'],
        ),
        false,
      ) ??
      $this->unsupportedType('interface');
  }

  public function keyset(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new KeysetTypeDescription($alias['counter'], $inner);
  }

  public function mixed(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new MixedTypeDescription($alias['counter']);
  }

  public function nonnull(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new NonnullTypeDescription($alias['counter']);
  }

  public function nothing(TAlias $alias)[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? $this->unsupportedType('nothing');
  }

  public function noreturn(TAlias $alias)[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? $this->unsupportedType('noreturn');
  }

  public function null(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new NullTypeDescription($alias['counter']);
  }

  public function nullable(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    $inner = $this->resolveAlias($alias, false) ?? $inner;
    $alias_name = $alias['alias'];

    // See tests/why-user-supplied-function-is-special.md
    if (!$inner->isUserSuppliedFunction() || $alias_name is null) {
      return new NullableTypeDescription($alias['counter'], $inner);
    }

    return $inner->superTypeOfNull()
      ? $inner
      : new NullableTypeDescription($alias['counter'], $inner);
  }

  public function num(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new NumTypeDescription($alias['counter']);
  }

  public function resource(TAlias $alias)[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? $this->unsupportedType('resource');
  }

  public function shape(
    TAlias $alias,
    vec<ShapeField> $fields,
    bool $is_open,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new ShapeTypeDescription(
        $alias['counter'],
        $fields,
        $is_open,
        $this->options['closed_shape_suffix'] ?? '',
      );
  }

  public function string(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ??
      new StringTypeDescription($alias['counter']);
  }

  public function trait(
    TAlias $alias,
    string $classname,
    vec<mixed> $_generics,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      $this->resolveAlias(
        shape(
          'alias' => $classname,
          'counter' => $alias['counter'],
          'opaque' => $alias['opaque'],
        ),
        false,
      ) ??
      $this->unsupportedType('trait');
  }

  public function tuple(
    TAlias $alias,
    vec<TypeDescription> $elements,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new TupleTypeDescription($alias['counter'], $elements);
  }

  public function vec(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new VecTypeDescription($alias['counter'], $inner);
  }

  public function vecOrDict(
    TAlias $alias,
    vec<TypeDescription> $inner,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new VecOrDictTypeDescription(
        $alias['counter'],
        C\count($inner) === 2
          ? $inner[0]
          : new ArraykeyTypeDescription($alias['counter']),
        C\lastx($inner),
      );
  }

  public function void(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? $this->unsupportedType('void');
  }

  private function resolveAlias(
    TAlias $alias,
    bool $is_arraykey,
  )[]: ?TypeDescription {
    $name = $alias['alias'];
    $opaque = $alias['opaque'];

    if ($name is null) {
      return null;
    }

    $asserter = $this->findAsserter($name, $alias['typevar_types'] ?? dict[]);

    if ($asserter is nonnull) {
      return new CallThisUserSuppliedFunction(
        $alias['counter'],
        $asserter['assert'],
        $is_arraykey,
        $asserter['nullable'],
      );
    }

    if ($opaque) {
      return $this->panic(Str\format(
        'Could not generate typesafe code for %s. '.
        'This type is a newtype and no $type_alias_asserters entry was provided.',
        $name,
      ));
    }

    return null;
  }

  private function findAsserter(
    string $name,
    KeyedContainer<string, mixed> $type_arguments,
  )[]: ?shape('assert' => string, 'nullable' => bool/*_*/) {
    $asserters = $this->typeAliasAsserters;
    $nullable_arguments = dict[];
    foreach ($type_arguments as $parameter => $argument) {
      $nullable_arguments[$parameter] =
        static::typeAcceptsNull($argument as dict<_, _>, dict[]);
    }

    while ($name !== null && !C\contains_key($asserters, $name)) {
      $type = static::reflectAlias($name);
      $inner_name = static::tryGetInnerAlias($name);
      $nullable_arguments = $inner_name is null || $type is null
        ? dict[]
        : static::innerNullableArguments(
            $inner_name,
            $type,
            $nullable_arguments,
          );
      $name = $inner_name;
    }

    $asserter = idx($asserters, $name);

    if ($asserter is null || $name is null) {
      return null;
    }

    return shape(
      'assert' => $asserter,
      'nullable' => static::typeAcceptsNull(
        static::reflectAlias($name) ?? dict[],
        $nullable_arguments,
      ),
    );
  }

  private static function tryGetInnerAlias(string $name)[]: ?string {
    $type = static::reflectAlias($name);
    // Transparent aliases may forward to a handler, but each newtype needs
    // its own upcast, even when its underlying type has a handler.
    if (($type['opaque'] ?? false) === true) {
      return null;
    }
    return $type['classname'] ?? null |> $$ as ?string;
  }

  private static function typeAcceptsNull(
    dict<arraykey, mixed> $type,
    dict<string, bool> $arguments,
  )[]: bool {
    if (($type['nullable'] ?? false) === true) {
      return true;
    }

    switch ($type['kind'] ?? null) {
      case HH\TypeStructureKind::OF_NULL:
      case HH\TypeStructureKind::OF_MIXED:
      case HH\TypeStructureKind::OF_DYNAMIC:
        return true;
      case HH\TypeStructureKind::OF_GENERIC:
        $parameter = $type['name'] ?? null;
        return $parameter is string && ($arguments[$parameter] ?? false);
      case HH\TypeStructureKind::OF_UNRESOLVED:
        $name = $type['classname'] ?? null;
        if (!$name is string) {
          return false;
        }
        return static::typeAcceptsNull(
          static::reflectAlias($name) ?? dict[],
          static::innerNullableArguments($name, $type, $arguments),
        );
      default:
        return false;
    }
  }

  private static function innerNullableArguments(
    string $name,
    dict<arraykey, mixed> $type,
    dict<string, bool> $arguments,
  )[]: dict<string, bool> {
    $parameters = static::reflectAlias($name)['typevars'] ?? '';
    $parameters = Str\split($parameters as string, ',');
    $types = $type['generic_types'] ?? vec[];
    $types = $types as KeyedContainer<_, _>;
    $result = dict[];
    foreach ($parameters as $index => $parameter) {
      $argument = $types[$index] ?? null;
      if ($argument is nonnull) {
        $result[$parameter] =
          static::typeAcceptsNull($argument as dict<_, _>, $arguments);
      }
    }
    return $result;
  }

  private static function reflectAlias(string $name)[]: ?dict<arraykey, mixed> {
    try {
      return new ReflectionTypeAlias($name)
        |> $$->getTypeStructure();
    } catch (ReflectionException $_) {
      return null;
    }
  }
}
