/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:a3c8a9729f15d492898d'])>>

final class VecTestCodegenTargetClass {
  public static function vecOfNum(mixed $htl_untyped_variable)[]: vec<num> {
    $out__1 = vec[];
    foreach (($htl_untyped_variable as vec<_>) as $v__1) {
      $out__1[] = $v__1 as num;
    }
    return $out__1;
  }
  public static function vecOfMixed(mixed $htl_untyped_variable)[]: vec<mixed> {
    return $htl_untyped_variable as vec<_>;
  }
}
