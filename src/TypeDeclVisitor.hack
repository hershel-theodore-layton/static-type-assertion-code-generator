/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

interface TypeDeclVisitor<Tt, Tf> {
  /**
   * Invoked when a bad type declaration is encountered,
   * f.e. a `vec<T>` without an inner type (`T`),
   */
  public function panic(string $message)[]: nothing;

  public function arraykey(TAlias $alias)[]: Tt;
  public function bool(TAlias $alias)[]: Tt;
  public function dict(TAlias $alias, Tt $key, Tt $value)[]: Tt;
  public function enum(TAlias $alias, string $classname)[]: Tt;
  public function float(TAlias $alias)[]: Tt;
  public function int(TAlias $alias)[]: Tt;
  public function keyset(TAlias $alias, Tt $inner)[]: Tt;
  public function mixed(TAlias $alias)[]: Tt;
  public function nonnull(TAlias $alias)[]: Tt;
  public function null(TAlias $alias)[]: Tt;
  public function nullable(TAlias $alias, Tt $inner)[]: Tt;
  public function num(TAlias $alias)[]: Tt;
  public function shape(TAlias $alias, vec<Tf> $fields, bool $is_open)[]: Tt;
  public function shapeField(arraykey $key, bool $cns, bool $opt, Tt $ty)[]: Tf;
  public function string(TAlias $alias)[]: Tt;
  public function tuple(TAlias $alias, vec<Tt> $elements)[]: Tt;
  public function vec(TAlias $alias, Tt $inner)[]: Tt;
}
