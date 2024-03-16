/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class VecOrDictTestCodegenTargetClass {
  public static function topTypeOneGeneric(
    mixed $htl_untyped_variable,
  ): vec_or_dict<mixed> {
    return $htl_untyped_variable as vec_or_dict<_>;
  }
  public static function topTypeTwoGenerics(
    mixed $htl_untyped_variable,
  ): vec_or_dict<arraykey, mixed> {
    return $htl_untyped_variable as vec_or_dict<_>;
  }
  public static function intKeyed(
    mixed $htl_untyped_variable,
  ): vec_or_dict<int, mixed> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as vec_or_dict<_>) as $k__1 => $v__1) {
      $out__1[$k__1 as int] = $v__1;
    }
    $out__1 = $htl_untyped_variable is vec<_> ? vec($out__1) : $out__1;
    return $out__1;
  }
  public static function validateValue(
    mixed $htl_untyped_variable,
  ): vec_or_dict<keyset<string>> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as vec_or_dict<_>) as $k__1 => $v__1) {
      $out__2 = keyset[];
      foreach (($v__1 as keyset<_>) as $k__2) {
        $out__2[] = $k__2 as string;
      }
      $out__1[$k__1] = $out__2;
    }
    $out__1 = $htl_untyped_variable is vec<_> ? vec($out__1) : $out__1;
    return $out__1;
  }
  public static function validateKeyAndValue(
    mixed $htl_untyped_variable,
  ): vec_or_dict<int, keyset<string>> {
    $out__1 = dict[];
    foreach (($htl_untyped_variable as vec_or_dict<_>) as $k__1 => $v__1) {
      $out__3 = keyset[];
      foreach (($v__1 as keyset<_>) as $k__3) {
        $out__3[] = $k__3 as string;
      }
      $out__1[$k__1 as int] = $out__3;
    }
    $out__1 = $htl_untyped_variable is vec<_> ? vec($out__1) : $out__1;
    return $out__1;
  }
}
