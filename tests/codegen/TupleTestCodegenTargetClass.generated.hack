/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class TupleTestCodegenTargetClass {
  public static function tupleNonnull(mixed $htl_static_type_assertion_codegen_seed_expression): (nonnull) { return $htl_static_type_assertion_codegen_seed_expression as (nonnull); }
  public static function tupleNull(mixed $htl_static_type_assertion_codegen_seed_expression): (null) { return $htl_static_type_assertion_codegen_seed_expression as (null); }
  public static function tupleMixedMixedMixed(mixed $htl_static_type_assertion_codegen_seed_expression): (mixed, mixed, mixed) { return $htl_static_type_assertion_codegen_seed_expression as (mixed, mixed, mixed); }
  public static function tupleIntMixedVecOfIntBool(mixed $htl_static_type_assertion_codegen_seed_expression): (int, vec<int>, bool) { return () ==> { $partial__0 = $htl_static_type_assertion_codegen_seed_expression as (int, mixed, bool); return tuple($partial__0[0], () ==> { $out__1 = vec[]; foreach (($partial__0[1] as vec<_>) as $v__2) { $out__1[] = $v__2 as int; } return $out__1; }(), $partial__0[2]); }(); }
  public static function tupleIntMixedVecOfMixedBool(mixed $htl_static_type_assertion_codegen_seed_expression): (int, vec<mixed>, bool) { return $htl_static_type_assertion_codegen_seed_expression as (int, vec<_>, bool); }
}
