/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;
use namespace HTL\StaticTypeAssertionCodegen;

final class ExoticTypesTest extends HackTest {
  public function test_vec_or_dict(): void {
    $this->expectItLooksLike<dynamic>('dynamic');
    $this->expectItLooksLike<nothing>('nothing');
    $this->expectItLooksLike<resource>('resource');
    $this->expectItLooksLike<vec_or_dict<string, int>>(
      'vec_or_dict<string, int>',
    );

    // class
    $this->expectItLooksLike<\DateTime>(\DateTime::class);
    // interface
    $this->expectItLooksLike<\JsonSerializable>(\JsonSerializable::class);
    // trait
    $this->expectItLooksLike<
      StaticTypeAssertionCodegen\_Private\NotASpecialType,
    >(StaticTypeAssertionCodegen\_Private\NotASpecialType::class);
  }

  public function expectItLooksLike<reify T>(string $expected): void {
    $genned_type = StaticTypeAssertionCodegen\from_type_with_visitor<T, _, _>(
      new TypeToString(),
    );

    expect($genned_type)->toEqual($expected);
  }
}
