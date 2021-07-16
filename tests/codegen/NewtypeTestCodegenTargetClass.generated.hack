/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class NewtypeTestCodegenTargetClass {
  public static function opaquenessUsingUserResolvedFunctions(mixed $htl_untyped_variable): dict<\HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt, \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt> { $out__0 = dict[]; foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__2) { $out__0[\HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueInt($k__1)] = \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueInt($v__2); } return $out__0; }
}
