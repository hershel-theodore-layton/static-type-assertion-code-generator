/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class NewtypeTestCodegenTargetClass {
  public static function opaquenessUsingUserResolvedFunctions(
    mixed $htl_untyped_variable,
  )[]: dict<
    \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt,
    \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt,
  > {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__1[\HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt(
        $k__1,
      )] =
        \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt(
          $v__1,
        );
    }
    return $out__1;
  }
  public static function nullIsPassedToInherentlyNullableUserFunction(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TNullable {
    return
      \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertNullableWithSentinal(
        $htl_untyped_variable,
      );
  }
  public static function nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TNullable {
    return
      \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertNullableWithSentinal(
        $htl_untyped_variable,
      );
  }
  public static function foo(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TNullableShape {
    return $htl_untyped_variable as ?shape(
      'a' => int,
      ...
    );
  }
  public static function keysetOfTOpaqueIntAsInt(
    mixed $htl_untyped_variable,
  )[]: keyset<\HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt> {
    $out__1 = keyset[];
    foreach (($htl_untyped_variable as keyset<_>) as $k__1) {
      $out__1[] =
        \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt(
          $k__1,
        );
    }
    return $out__1;
  }
  public static function vecOfNullableTOpaqueIntAsInt(
    mixed $htl_untyped_variable,
  )[]: vec<?\HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt> {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      if ($v__1 is null) {
        $out__2 = null;
      } else {
        $out__2 =
          \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertOpaqueIntAsInt(
            $v__1,
          );
      }
      $out__1[] = $out__2;
    }
    return $out__1;
  }
  public static function vecOfNullableTNullableOpaqueIntAsNullableInt(
    mixed $htl_untyped_variable,
  )[]: vec<\HTL\StaticTypeAssertionCodegen\Tests\TNullableOpaqueIntAsNullableInt> {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      $out__1[] =
        \HTL\StaticTypeAssertionCodegen\Tests\NewtypeTest::assertNullableOpaqueIntAsNullableInt(
          $v__1,
        );
    }
    return $out__1;
  }
}
