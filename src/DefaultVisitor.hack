/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

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
  VecTypeDescription,
};
use type HTL\TypeVisitor\{TAlias, TypeDeclVisitor};

final class DefaultVisitor
  implements TypeDeclVisitor<TypeDescription, ShapeField> {

  public function __construct(
    private dict<string, string> $typeAliasAsserters,
    private (function(string)[]: nothing) $panic,
    private (function(?string, arraykey)[]: ?string) $shapeFieldNameResolver,
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

      $repr = _Private\string_export($key);
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
    return $this->resolveAlias($alias, false) ??
      new NullableTypeDescription($alias['counter'], $inner);
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
      new ShapeTypeDescription($alias['counter'], $fields, $is_open);
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
    vec<TypeDescription> $_inner,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      $this->unsupportedType('vec_or_dict');
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

    if (C\contains_key($this->typeAliasAsserters, $name)) {
      return new CallThisUserSuppliedFunction(
        $alias['counter'],
        $this->typeAliasAsserters[$name],
        $is_arraykey,
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
}
