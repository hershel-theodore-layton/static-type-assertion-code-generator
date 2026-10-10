/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:72dd0a69c4cb15d9259b'])>>

final class NewtypeTestCodegenTargetClass {
  public static function opaquenessUsingUserResolvedFunctions(
    mixed $htl_untyped_variable,
  )[]: dict<
    \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt,
    \HTL\StaticTypeAssertionCodegen\Tests\TOpaqueIntAsInt,
  > {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__1[assert_opaque_int_as_int($k__1)] =
        assert_opaque_int_as_int($v__1);
    }
    return $out__1;
  }
  public static function nullIsPassedToInherentlyNullableUserFunction(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TNullable {
    return assert_nullable_with_sentinal($htl_untyped_variable);
  }
  public static function nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TNullable {
    return assert_nullable_with_sentinal($htl_untyped_variable);
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
      $out__1[] = assert_opaque_int_as_int($k__1);
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
        $out__2 = assert_opaque_int_as_int($v__1);
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
      $out__1[] = assert_nullable_opaque_int_as_nullable_int($v__1);
    }
    return $out__1;
  }
  public static function genericNullableIdentity(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TGenericIdentity<?int> {
    return assert_generic_nullable_identity($htl_untyped_variable);
  }
  public static function redundantlyNullableGenericIdentity(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericIdentity<?int> {
    return assert_generic_nullable_identity($htl_untyped_variable);
  }
  public static function externallyNullableGenericIdentity(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericIdentity<int> {
    if ($htl_untyped_variable is null) {
      $out__1 = null;
    } else {
      $out__1 = assert_generic_identity($htl_untyped_variable);
    }
    return $out__1;
  }
  public static function genericDynamicIdentity(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericIdentity<dynamic> {
    return assert_generic_dynamic($htl_untyped_variable);
  }
  public static function genericMaybe(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TGenericMaybe<int> {
    return assert_generic_maybe($htl_untyped_variable);
  }
  public static function genericNested(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TGenericNested<?int> {
    return assert_generic_nested($htl_untyped_variable);
  }
  public static function genericTransparent(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TGenericTransparent<?int> {
    return assert_generic_nullable_identity($htl_untyped_variable);
  }
  public static function externallyNullableGenericTransparent(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericTransparent<int> {
    if ($htl_untyped_variable is null) {
      $out__1 = null;
    } else {
      $out__1 = assert_generic_identity($htl_untyped_variable);
    }
    return $out__1;
  }
  public static function externallyNullableGenericVector(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericVector<?int> {
    if ($htl_untyped_variable is null) {
      $out__1 = null;
    } else {
      $out__1 = assert_generic_vector($htl_untyped_variable);
    }
    return $out__1;
  }
}
