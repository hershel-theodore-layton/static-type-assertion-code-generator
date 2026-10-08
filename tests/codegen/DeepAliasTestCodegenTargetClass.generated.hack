/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:006644a31323173aface'])>>

final class DeepAliasTestCodegenTargetClass {
  public static function level1(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TLevel1 {
    return level_1_and_2($htl_untyped_variable);
  }
  public static function level2(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TLevel2 {
    return level_1_and_2($htl_untyped_variable);
  }
  public static function level3(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TLevel3 {
    return level_3_and_4_and_5($htl_untyped_variable);
  }
  public static function level4(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TLevel4 {
    return level_3_and_4_and_5($htl_untyped_variable);
  }
  public static function level5(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TLevel5 {
    return level_3_and_4_and_5($htl_untyped_variable);
  }
  public static function yesNo(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\YesNo {
    return yes_no($htl_untyped_variable);
  }
  public static function maybeYesNo(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\MaybeYesNo {
    if ($htl_untyped_variable is null) {
      $out__1 = null;
    } else {
      $out__1 = yes_no($htl_untyped_variable);
    }
    return $out__1;
  }
  public static function opaqueOuter(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryOuter {
    return assert_boundary_outer($htl_untyped_variable);
  }
  public static function transparentOuter(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryTransparentOuter {
    return assert_boundary_outer($htl_untyped_variable);
  }
  public static function longChain(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryLongChain {
    return assert_boundary_outer($htl_untyped_variable);
  }
  public static function nullableOuter(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryNullableOuter {
    if ($htl_untyped_variable is null) {
      $out__1 = null;
    } else {
      $out__1 = assert_boundary_outer($htl_untyped_variable);
    }
    return $out__1;
  }
  public static function opaqueOuterViaTransparent(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryOuterViaTransparent {
    return assert_boundary_outer_via_transparent($htl_untyped_variable);
  }
  public static function nullableBoundary(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryNullable {
    return assert_boundary_nullable($htl_untyped_variable);
  }
  public static function transparentInner(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TBoundaryTransparentInner {
    return assert_boundary_inner($htl_untyped_variable);
  }
}
