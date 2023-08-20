/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class NewtypeTestCodegenTargetClass {
  public static function opaquenessUsingUserResolvedFunctions(mixed $htl_untyped_variable): dict<\HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt, \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt> { $out__1 = dict[]; foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) { $out__1[\HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt($k__1)] = \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt($v__1); } return $out__1; }
  public static function keysetOfTOpaqueIntAsInt(mixed $htl_untyped_variable): keyset<\HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt> { $out__1 = keyset[]; foreach (($htl_untyped_variable as keyset<_>) as $k__1) { $out__1[] = \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt($k__1); } return $out__1; }
}
