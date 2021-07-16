/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class EnumTestCodegenTargetClass {
  public static function someEnum(mixed $htl_untyped_variable): \HTL\StaticTypeAssertionCodegen\Tests\SomeEnum { return \HTL\StaticTypeAssertionCodegen\Tests\EnumTest::assertEnum($htl_untyped_variable); }
}
