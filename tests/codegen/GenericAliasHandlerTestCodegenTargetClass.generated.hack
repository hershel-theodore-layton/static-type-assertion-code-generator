/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:e254f52f689e32849a83'])>>

final class GenericAliasHandlerTestCodegenTargetClass {
  public static function pair(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TSpecializedPair {
    $out__1 = $htl_untyped_variable as (mixed, mixed);
    $out__1 = tuple(assert_int_box($out__1[0]), assert_string_box($out__1[1]));
    return $out__1;
  }
  public static function nested(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TSpecializedNested {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      $out__2 = $v__1 as (mixed, mixed);
      $out__2 =
        tuple(assert_int_box($out__2[0]), assert_string_box($out__2[1]));
      $out__1[] = $out__2;
    }
    return $out__1;
  }
  public static function fallback(
    mixed $htl_untyped_variable,
  )[]: vec<\HTL\StaticTypeAssertionCodegen\Tests\TSpecializedBox<int>> {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      $out__1[] = assert_int_box($v__1);
    }
    return $out__1;
  }
  public static function nullable(
    mixed $htl_untyped_variable,
  )[]: ?\HTL\StaticTypeAssertionCodegen\Tests\TGenericIdentity<?int> {
    return assert_generic_nullable_identity($htl_untyped_variable);
  }
}
