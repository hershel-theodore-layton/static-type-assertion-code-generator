/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class ShapeTestCodegenTargetClass {
  public static function emptyShape(mixed $htl_untyped_variable): shape() { return $htl_untyped_variable as shape(); }
  public static function emptyShapeWithExtraFields(mixed $htl_untyped_variable): shape(...) { return $htl_untyped_variable as shape(...); }
  public static function shapeAToNullableInt(mixed $htl_untyped_variable): shape('a' => ?int) { return $htl_untyped_variable as shape('a' => ?int); }
  public static function shapeOptionalAToInt(mixed $htl_untyped_variable): shape(?'a' => int) { return $htl_untyped_variable as shape(?'a' => int); }
  public static function nullableShapeOptionalAToNullableIntWithExtraFields(mixed $htl_untyped_variable): ?shape(?'a' => ?int, ...) { return $htl_untyped_variable as ?shape(?'a' => ?int, ...); }
  public static function shapeOptionalAVecOfInt(mixed $htl_untyped_variable): shape(?'a' => vec<int>) { $partial__1 = $htl_untyped_variable as shape(?'a' => mixed); if (Shapes::keyExists($partial__1, 'a')) { $partial__1['a'] = () ==> { $out__2 = vec[]; foreach (($partial__1['a'] as vec<_>) as $v__2) { $out__2[] = $v__2 as int; } return $out__2; }(); } else { Shapes::removeKey(inout $partial__1, 'a'); } return $partial__1; }
  public static function shapeOptionalAVecOfIntBStringWithExtraFields(mixed $htl_untyped_variable): shape(?'a' => vec<int>, 'b' => string, ...) { $partial__1 = $htl_untyped_variable as shape(?'a' => mixed, 'b' => string, ...); if (Shapes::keyExists($partial__1, 'a')) { $partial__1['a'] = () ==> { $out__2 = vec[]; foreach (($partial__1['a'] as vec<_>) as $v__2) { $out__2[] = $v__2 as int; } return $out__2; }(); } else { Shapes::removeKey(inout $partial__1, 'a'); } return $partial__1; }
  public static function shapeWithUnicodeKey(mixed $htl_untyped_variable): shape('☃' => vec<string>) { $partial__1 = $htl_untyped_variable as shape('☃' => mixed); $partial__1['☃'] = () ==> { $out__2 = vec[]; foreach (($partial__1['☃'] as vec<_>) as $v__2) { $out__2[] = $v__2 as string; } return $out__2; }(); return $partial__1; }
  public static function shapeWithQuoteInKey(mixed $htl_untyped_variable): shape('\'' => vec<string>) { $partial__1 = $htl_untyped_variable as shape('\'' => mixed); $partial__1['\''] = () ==> { $out__2 = vec[]; foreach (($partial__1['\''] as vec<_>) as $v__2) { $out__2[] = $v__2 as string; } return $out__2; }(); return $partial__1; }
  public static function collidingKeys(mixed $htl_untyped_variable): shape(ShapeTest::ALSO_A => string) { return $htl_untyped_variable as shape(ShapeTest::ALSO_A => string); }
  public static function testingArgumentsPassedToTheFieldResolver(mixed $htl_untyped_variable): ExampleShape { return $htl_untyped_variable as shape('the_expected_name' => int); }
}
