/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class DictTestCodegenTargetClass {
  public static function dictIntToBool(
    mixed $htl_untyped_variable,
  )[]: dict<int, bool> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__1[$k__1 as int] = $v__1 as bool;
    }
    return $out__1;
  }
  public static function dictArraykeyToBool(
    mixed $htl_untyped_variable,
  )[]: dict<arraykey, bool> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__1[$k__1] = $v__1 as bool;
    }
    return $out__1;
  }
  public static function dictStringToMixed(
    mixed $htl_untyped_variable,
  )[]: dict<string, mixed> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
      $out__1[$k__1 as string] = $v__1;
    }
    return $out__1;
  }
  public static function dictArraykeyToMixed(
    mixed $htl_untyped_variable,
  )[]: dict<arraykey, mixed> {
    return $htl_untyped_variable as dict<_, _>;
  }
}
