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

final class DefaultVisitor
  implements TypeDeclVisitor<TypeDescription, ShapeField> {

  public function __construct(
    private dict<string, string> $typeAliasAsserters,
    private (function(string)[]: nothing) $panic,
  )[] {}

  public function panic(string $message)[]: nothing {
    return ($this->panic)($message);
  }

  public function shapeField(
    arraykey $key,
    bool $cns,
    bool $opt,
    _Private\TypeDescription $ty,
  )[]: ShapeField {
    if (!$key is string || $cns) {
      return $this->panic(
        'Shapes with class constant keys can not be safely codegenned.',
      );
    }

    return new ShapeField($key, _Private\string_export($key), $opt, $ty);
  }

  public function arraykey(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ?? new ArraykeyTypeDescription();
  }

  public function bool(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new BoolTypeDescription();
  }

  public function dict(
    TAlias $alias,
    TypeDescription $key,
    TypeDescription $value,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new DictTypeDescription($key, $value);
  }

  public function enum(TAlias $alias, string $classname)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ??
      $this->resolveAlias(
        shape('alias' => $classname, 'opaque' => $alias['opaque']),
        true,
      ) ??
      $this->panic(Str\format(
        'Support for enums must be added using a $type_alias_asserters entry, got %s'.
        'See the README to learn why.',
        $classname,
      ));
  }

  public function float(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new FloatTypeDescription();
  }

  public function int(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ?? new IntTypeDescription();
  }

  public function keyset(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? new KeysetTypeDescription($inner);
  }

  public function mixed(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new MixedTypeDescription();
  }

  public function nonnull(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new NonnullTypeDescription();
  }

  public function null(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new NullTypeDescription();
  }

  public function nullable(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? new NullableTypeDescription($inner);
  }

  public function num(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new NumTypeDescription();
  }

  public function shape(
    TAlias $alias,
    vec<ShapeField> $fields,
    bool $is_open,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ??
      new ShapeTypeDescription($fields, $is_open);
  }

  public function string(TAlias $alias)[]: TypeDescription {
    return $this->resolveAlias($alias, true) ?? new StringTypeDescription();
  }

  public function tuple(
    TAlias $alias,
    vec<TypeDescription> $elements,
  )[]: TypeDescription {
    return
      $this->resolveAlias($alias, false) ?? new TupleTypeDescription($elements);
  }

  public function vec(
    TAlias $alias,
    TypeDescription $inner,
  )[]: TypeDescription {
    return $this->resolveAlias($alias, false) ?? new VecTypeDescription($inner);
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
