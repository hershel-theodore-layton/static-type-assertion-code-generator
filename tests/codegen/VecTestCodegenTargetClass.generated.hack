/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class VecTestCodegenTargetClass {
  public static function vecOfNum(mixed $htl_static_type_assertion_codegen_seed_expression): vec<num> { return () ==> { $out__0 = vec[]; foreach (($htl_static_type_assertion_codegen_seed_expression as vec<_>) as $v__1) { $out__0[] = $v__1 as num; } return $out__0; }(); }
  public static function vecOfMixed(mixed $htl_static_type_assertion_codegen_seed_expression): vec<mixed> { return $htl_static_type_assertion_codegen_seed_expression as vec<_>; }
}
