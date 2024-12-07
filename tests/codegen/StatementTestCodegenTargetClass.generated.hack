/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class StatementTestCodegenTargetClass {
  public static function statementInDict(
    mixed $htl_untyped_variable,
  )[]: dict<int, vec<int>> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__3 = vec[];
      foreach (($v__1 as vec<_>) as $v__3) {
        $out__3[] = $v__3 as int;
      }
      $out__1[$k__1 as int] = $out__3;
    }

    return $out__1;
  }
  public static function statementInShape(
    mixed $htl_untyped_variable,
  )[]: shape('a' => vec<int>/*_*/) {
    $out__1 = $htl_untyped_variable as shape(
      'a' => mixed,
      /*_*/
    );
    $out__2 = vec[];
    foreach (($out__1['a'] as vec<_>) as $v__2) {
      $out__2[] = $v__2 as int;
    }
    $out__1['a'] = $out__2;

    return $out__1;
  }
  public static function statementInTuple(
    mixed $htl_untyped_variable,
  )[]: (vec<int>) {
    $out__1 = $htl_untyped_variable as (mixed);
    $out__2 = vec[];
    foreach (($out__1[0] as vec<_>) as $v__2) {
      $out__2[] = $v__2 as int;
    }
    $out__1 = tuple($out__2);
    return $out__1;
  }
  public static function statementInVec(
    mixed $htl_untyped_variable,
  )[]: vec<vec<int>> {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      $out__2 = vec[];
      foreach (($v__1 as vec<_>) as $v__2) {
        $out__2[] = $v__2 as int;
      }
      $out__1[] = $out__2;
    }

    return $out__1;
  }
  public static function deeplyNestedStatement(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\DeeplyNested {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__3 = $v__1 as (mixed);
      $out__4 = vec[];
      foreach (($out__3[0] as vec<_>) as $v__4) {
        $out__5 = $v__4 as shape(
          'a' => mixed,
          /*_*/
        );
        $out__6 = vec[];
        foreach (($out__5['a'] as vec<_>) as $v__6) {
          $out__6[] =
            \HTL\StaticTypeAssertionCodegen\Tests\StatementTest::hiddenInt(
              $v__6,
            );
        }
        $out__5['a'] = $out__6;
        $out__4[] = $out__5;
      }
      $out__3 = tuple($out__4);
      $out__1[$k__1 as int] = $out__3;
    }

    return $out__1;
  }
}
