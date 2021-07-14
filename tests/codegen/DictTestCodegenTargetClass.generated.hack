/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class DictTestCodegenTargetClass {
  public static function dictIntToBool(mixed $htl_static_type_assertion_codegen_seed_expression): dict<int, bool> { return () ==> { $out__0 = dict[]; foreach (($htl_static_type_assertion_codegen_seed_expression as dict<_, _>) as $k__1 => $v__2) { $out__0[$k__1 as int] = $v__2 as bool; } return $out__0; }(); }
  public static function dictArraykeyToBool(mixed $htl_static_type_assertion_codegen_seed_expression): dict<arraykey, bool> { return () ==> { $out__0 = dict[]; foreach (($htl_static_type_assertion_codegen_seed_expression as dict<_, _>) as $k__1 => $v__2) { $out__0[$k__1] = $v__2 as bool; } return $out__0; }(); }
  public static function dictStringToMixed(mixed $htl_static_type_assertion_codegen_seed_expression): dict<string, mixed> { return () ==> { $out__0 = dict[]; foreach (($htl_static_type_assertion_codegen_seed_expression as dict<_, _>) as $k__1 => $v__2) { $out__0[$k__1 as string] = $v__2; } return $out__0; }(); }
  public static function dictArraykeyToMixed(mixed $htl_static_type_assertion_codegen_seed_expression): dict<arraykey, mixed> { return $htl_static_type_assertion_codegen_seed_expression as dict<_, _>; }
}
