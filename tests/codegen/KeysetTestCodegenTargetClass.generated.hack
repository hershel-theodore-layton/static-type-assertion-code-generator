/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:d9ac8e12e9d16edc06d1'])>>

final class KeysetTestCodegenTargetClass {
  public static function keysetOfString(
    mixed $htl_untyped_variable,
  )[]: keyset<string> {
    $out__1 = keyset[];
    foreach (($htl_untyped_variable as keyset<_>) as $k__1) {
      $out__1[] = $k__1 as string;
    }
    return $out__1;
  }
  public static function keysetOfArrayKey(
    mixed $htl_untyped_variable,
  )[]: keyset<arraykey> {
    return $htl_untyped_variable as keyset<_>;
  }
}
