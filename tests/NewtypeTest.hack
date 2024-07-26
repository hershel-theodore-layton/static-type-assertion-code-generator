/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\Str;
use namespace HTL\StaticTypeAssertionCodegen;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

type TIntAlias = int;
newtype TOpaqueIntAsInt as int = int;
newtype TOpaqueInt = int;
type TVecOfIntAlias = vec<int>;
newtype TOpaqueVecOfIntAsVecOfInt as vec<int> = vec<int>;
newtype TOpaqueVecOfInt = vec<int>;

final class NewtypeTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(
  )[defaults]: Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<dict<TOpaqueIntAsInt, TOpaqueIntAsInt>>(
      'opaquenessUsingUserResolvedFunctions',
      dict[
        TOpaqueIntAsInt::class => '\\'.static::class.'::assertOpaqueIntAsInt',
      ],
    );
    $ch->createMethod<keyset<TOpaqueIntAsInt>>(
      'keysetOfTOpaqueIntAsInt',
      dict[
        TOpaqueIntAsInt::class => '\\'.static::class.'::assertOpaqueIntAsInt',
      ],
    );
  }

  public function test_throws_when_no_newtype_handler_was_provided(
  )[defaults]: void {
    expect(
      () ==> StaticTypeAssertionCodegen\from_type<TOpaqueInt>(dict[], panic<>),
    )
      ->toThrow(
        InvariantException::class,
        'This type is a newtype and no $type_alias_asserters entry was provided.',
      );
  }

  public function test_uses_user_provided_asserters()[defaults]: void {
    static::okayValues<dict<TOpaqueIntAsInt, TOpaqueIntAsInt>>(
      NewtypeTestCodegenTargetClass::opaquenessUsingUserResolvedFunctions<>,
      dict[
        'empty dict' => dict[],
        'dict TOpaqueIntAsInt to TOpaqueIntAsInt' => dict[123 => 456],
      ],
    );

    static::badValues(
      NewtypeTestCodegenTargetClass::opaquenessUsingUserResolvedFunctions<>,
      dict[
        'dict int to TOpaqueIntAsInt' => dict[-123 => 456],
        'dict TOpaqueIntAsInt to int' => dict[123 => -456],
      ],
    );
  }

  public function test_types_backend_by_arraykeys_can_be_used_as_an_arraykey(
  )[defaults]: void {
    static::okayValues<keyset<TOpaqueIntAsInt>>(
      NewtypeTestCodegenTargetClass::keysetOfTOpaqueIntAsInt<>,
      dict[
        'empty keyset' => keyset[],
        'keyset of TOpaqueIntAsInt' => keyset[6],
      ],
    );
  }

  // This reflection hack has since been moved to the HTL\TypeVisitor repo.
  public function test_if_this_test_fails_you_can_remove_the_cleaning_opaque_reflection_hack(
  )[defaults]: void {
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

  public static function assertOpaqueIntAsInt(mixed $mixed)[]: TOpaqueIntAsInt {
    if (($mixed as int) < 0) {
      throw new \TypeAssertionException(
        Str\format(
          'Expected a %s, got a negative integer',
          TOpaqueIntAsInt::class,
        ),
      );
    }
    return $mixed;
  }
}
