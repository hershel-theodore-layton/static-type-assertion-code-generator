/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class TupleTestCodegenTargetClass {
  public static function tupleNonnull(mixed $htl_untyped_variable): (nonnull) { return $htl_untyped_variable as (nonnull); }
  public static function tupleNull(mixed $htl_untyped_variable): (null) { return $htl_untyped_variable as (null); }
  public static function tupleMixedMixedMixed(mixed $htl_untyped_variable): (mixed, mixed, mixed) { return $htl_untyped_variable as (mixed, mixed, mixed); }
  public static function tupleIntMixedVecOfIntBool(mixed $htl_untyped_variable): (int, vec<int>, bool) { $partial__0 = $htl_untyped_variable as (int, mixed, bool); return tuple($partial__0[0], () ==> { $out__1 = vec[]; foreach (($partial__0[1] as vec<_>) as $v__2) { $out__1[] = $v__2 as int; } return $out__1; }(), $partial__0[2]); }
  public static function tupleIntMixedVecOfMixedBool(mixed $htl_untyped_variable): (int, vec<mixed>, bool) { return $htl_untyped_variable as (int, vec<_>, bool); }
}
