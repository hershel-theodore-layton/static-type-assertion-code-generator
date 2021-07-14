/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class KeysetTestCodegenTargetClass {
  public static function keysetOfString(mixed $htl_static_type_assertion_codegen_seed_expression): keyset<string> { return () ==> { $out__0 = keyset[]; foreach (($htl_static_type_assertion_codegen_seed_expression as keyset<_>) as $k__1) { $out__0[] = $k__1 as string; } return $out__0; }(); }
  public static function keysetOfArrayKey(mixed $htl_static_type_assertion_codegen_seed_expression): keyset<arraykey> { return $htl_static_type_assertion_codegen_seed_expression as keyset<_>; }
}
