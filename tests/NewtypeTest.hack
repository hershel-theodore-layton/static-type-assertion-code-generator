/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;
use namespace HTL\StaticTypeAssertionCodegen;
use function Facebook\FBExpect\expect;
use function HTL\StaticTypeAssertionCodegen\_Private\clean_type_structure;

type TIntAlias = int;
newtype TOpaqueIntAsInt as int = int;
newtype TOpaqueInt = int;
type TVecOfIntAlias = vec<int>;
newtype TOpaqueVecOfIntAsVecOfInt as vec<int> = vec<int>;
newtype TOpaqueVecOfInt = vec<int>;

final class NewtypeTest extends HackTest {
  public function test_accept_newtypes(): void {
    expect(() ==> StaticTypeAssertionCodegen\from_type<TOpaqueInt>())
      ->notToThrow();
  }

  public function test_reified_generics_do_not_appear_consistently(): void {
    expect(static::isOpaque<TIntAlias>())->toBeNull();
    expect(static::isOpaque<TOpaqueIntAsInt>())->toBeTrue();
    expect(static::isOpaque<TOpaqueInt>())->toBeTrue();
    expect(static::isOpaque<TVecOfIntAlias>())->toBeNull();
    expect(static::isOpaque<TOpaqueVecOfIntAsVecOfInt>())->toBeTrue();
    expect(static::isOpaque<TOpaqueVecOfInt>())->toBeTrue();
  }

  public function test_if_this_test_fails_you_can_remove_the_cleaning_opaque_reflection_hack(
  ): void {
    expect(
      Shapes::idx(
        \HH\ReifiedGenerics\get_type_structure<TOpaqueVecOfIntAsVecOfInt>(),
        'opaque',
        '<missing>',
      ),
    )->toEqual('<missing>');
    expect(
      Shapes::idx(
        \HH\ReifiedGenerics\get_type_structure<TOpaqueVecOfInt>(),
        'opaque',
        '<missing>',
      ),
    )->toEqual('<missing>');
  }

  private static function isOpaque<reify T>(): ?bool {
    return \HH\ReifiedGenerics\get_type_structure<T>()
      |> clean_type_structure($$)
      |> Shapes::idx($$, 'opaque');
  }
}
