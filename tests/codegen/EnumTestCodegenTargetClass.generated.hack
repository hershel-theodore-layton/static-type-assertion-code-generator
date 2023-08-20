/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class EnumTestCodegenTargetClass {
  public static function someEnum(mixed $htl_untyped_variable): \HTL\StaticTypeAssertionCodegen\Tests\SomeEnum { return \HTL\StaticTypeAssertionCodegen\Tests\EnumTest::assertEnum($htl_untyped_variable); }
  public static function keysetOfSomeEnum(mixed $htl_untyped_variable): keyset<\HTL\StaticTypeAssertionCodegen\Tests\SomeEnum> { $out__1 = keyset[]; foreach (($htl_untyped_variable as keyset<_>) as $k__1) { $out__1[] = \HTL\StaticTypeAssertionCodegen\Tests\EnumTest::assertEnum($k__1); } return $out__1; }
}
