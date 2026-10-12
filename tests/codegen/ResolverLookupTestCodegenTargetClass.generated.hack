/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:02316f29b0010f2ab288'])>>

final class ResolverLookupTestCodegenTargetClass {
  public static function classAlias(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TResolverClassAlias {
    return assert_resolver_class($htl_untyped_variable);
  }
  public static function genericClassAlias(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TResolverGenericClassAlias {
    return assert_resolver_generic_class($htl_untyped_variable);
  }
  public static function nestedArguments(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TResolverOuter<int> {
    return assert_vector_int_box($htl_untyped_variable);
  }
  public static function nullableArgument(
    mixed $htl_untyped_variable,
  )[]: \HTL\StaticTypeAssertionCodegen\Tests\TResolverNullable<int> {
    return assert_generic_nullable_identity($htl_untyped_variable);
  }
}
