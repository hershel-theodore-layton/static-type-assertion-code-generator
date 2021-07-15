/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;
use namespace HTL\StaticTypeAssertionCodegen;
use function Facebook\FBExpect\expect;

newtype TOpaqueInt = int;
newtype TOpaqueVecOfInt = vec<int>;

final class NewtypeTest extends HackTest {
  public function test_accept_newtypes(): void {
    expect(() ==> StaticTypeAssertionCodegen\from_type<TOpaqueInt>())
      ->notToThrow();
  }

  public function test_reified_generics_do_not_appear_consistently(): void {
    expect(Shapes::idx(
      \HH\ReifiedGenerics\get_type_structure<TOpaqueInt>(),
      'opaque',
      '<missing>',
    ))->toEqual(true);
    expect(Shapes::idx(
      \HH\ReifiedGenerics\get_type_structure<TOpaqueVecOfInt>(),
      'opaque',
      '<missing>',
    ))->toEqual('<missing>');
  }
}
