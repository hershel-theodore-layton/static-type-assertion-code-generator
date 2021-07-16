/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str};
use namespace HTL\StaticTypeAssertionCodegen;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

enum SomeEnum: int {
  ONE = 1;
}

final class EnumTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<SomeEnum>(
      'someEnum',
      '\\'.SomeEnum::class,
      dict[SomeEnum::class => static::class.'::assertEnum'],
    );
    $ch->createMethod<keyset<SomeEnum>>(
      'keysetOfSomeEnum',
      'keyset<\\'.SomeEnum::class.'>',
      dict[SomeEnum::class => static::class.'::assertEnum'],
    );
  }

  public function test_throws_when_no_enum_handler_was_provided(): void {
    expect(() ==> StaticTypeAssertionCodegen\from_type<SomeEnum>())
      ->toThrow(
        InvariantException::class,
        'Support for enums must be added using TTypeAliasAsserters',
      );
  }

  public function test_uses_user_provided_asserters(): void {
    static::okayValues<SomeEnum>(
      $x ==> EnumTestCodegenTargetClass::someEnum($x),
      dict['member of SomeEnum' => SomeEnum::ONE],
    );
  }

  public function test_can_be_used_as_an_arraykey(): void {
    static::okayValues<keyset<SomeEnum>>(
      $x ==> EnumTestCodegenTargetClass::keysetOfSomeEnum($x),
      dict[
        'empty keyset' => keyset[],
        'keyset of SomeEnum' => keyset[SomeEnum::ONE],
      ],
    );
  }

  public static function assertEnum(mixed $m): SomeEnum {
    if ($m is arraykey && C\contains_key(SomeEnum::getNames(), $m)) {
      return $m as SomeEnum;
    } else {
      throw new \TypeAssertionException(Str\format(
        'Expected %s, got %s',
        SomeEnum::class,
        \is_object($m) ? \get_class($m) : \gettype($m),
      ));
    }
  }
}
