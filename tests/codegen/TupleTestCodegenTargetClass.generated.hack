/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class TupleTestCodegenTargetClass {
  public static function tupleNonnull(mixed $htl_untyped_variable): (nonnull) { return $htl_untyped_variable as (nonnull); }
  public static function tupleNull(mixed $htl_untyped_variable): (null) { return $htl_untyped_variable as (null); }
  public static function tupleMixedMixedMixed(mixed $htl_untyped_variable): (mixed, mixed, mixed) { return $htl_untyped_variable as (mixed, mixed, mixed); }
  public static function tupleIntMixedVecOfIntBool(mixed $htl_untyped_variable): (int, vec<int>, bool) { $partial__1 = $htl_untyped_variable as (int, mixed, bool); return tuple($partial__1[0], () ==> { $out__3 = vec[]; foreach (($partial__1[1] as vec<_>) as $v__3) { $out__3[] = $v__3 as int; } return $out__3; }(), $partial__1[2]); }
  public static function tupleIntMixedVecOfMixedBool(mixed $htl_untyped_variable): (int, vec<mixed>, bool) { return $htl_untyped_variable as (int, vec<_>, bool); }
}
