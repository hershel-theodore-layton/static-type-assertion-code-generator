/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class ShapeTestCodegenTargetClass {
  public static function emptyShape(mixed $htl_untyped_variable): shape() { return $htl_untyped_variable as shape(); }
  public static function emptyShapeWithExtraFields(mixed $htl_untyped_variable): shape(...) { return $htl_untyped_variable as shape(...); }
  public static function shapeAToNullableInt(mixed $htl_untyped_variable): shape('a' => ?int) { return $htl_untyped_variable as shape('a' => ?int); }
  public static function shapeOptionalAToInt(mixed $htl_untyped_variable): shape(?'a' => int) { return $htl_untyped_variable as shape(?'a' => int); }
  public static function nullableShapeOptionalAToNullableIntWithExtraFields(mixed $htl_untyped_variable): ?shape(?'a' => ?int, ...) { return $htl_untyped_variable as ?shape(?'a' => ?int, ...); }
  public static function shapeOptionalAVecOfInt(mixed $htl_untyped_variable): shape(?'a' => vec<int>) { return () ==> { $partial__0 = $htl_untyped_variable as shape(?'a' => mixed); if (Shapes::keyExists($partial__0, 'a')) { $partial__0['a'] = () ==> { $out__1 = vec[]; foreach (($partial__0['a'] as vec<_>) as $v__2) { $out__1[] = $v__2 as int; } return $out__1; }(); } else { Shapes::removeKey(inout $partial__0, 'a'); } return $partial__0; }(); }
  public static function shapeOptionalAVecOfIntBStringWithExtraFields(mixed $htl_untyped_variable): shape(?'a' => vec<int>, 'b' => string, ...) { return () ==> { $partial__0 = $htl_untyped_variable as shape(?'a' => mixed, 'b' => string, ...); if (Shapes::keyExists($partial__0, 'a')) { $partial__0['a'] = () ==> { $out__1 = vec[]; foreach (($partial__0['a'] as vec<_>) as $v__2) { $out__1[] = $v__2 as int; } return $out__1; }(); } else { Shapes::removeKey(inout $partial__0, 'a'); } return $partial__0; }(); }
  public static function shapeWithUnicodeKey(mixed $htl_untyped_variable): shape('☃' => vec<string>) { return () ==> { $partial__0 = $htl_untyped_variable as shape('☃' => mixed); $partial__0['☃'] = () ==> { $out__1 = vec[]; foreach (($partial__0['☃'] as vec<_>) as $v__2) { $out__1[] = $v__2 as string; } return $out__1; }(); return $partial__0; }(); }
  public static function shapeWithQuoteInKey(mixed $htl_untyped_variable): shape('\'' => vec<string>) { return () ==> { $partial__0 = $htl_untyped_variable as shape('\'' => mixed); $partial__0['\''] = () ==> { $out__1 = vec[]; foreach (($partial__0['\''] as vec<_>) as $v__2) { $out__1[] = $v__2 as string; } return $out__1; }(); return $partial__0; }(); }
}
