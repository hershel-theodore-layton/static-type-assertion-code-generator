/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str};
use namespace HTL\StaticTypeAssertionCodegen;
use type Facebook\HackTest\HackTest;
use function HTL\Expect\expect_invoked;

enum SomeEnum: int {
  ONE = 1;
}

final class EnumTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(
  )[defaults]: Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<SomeEnum>(
      'someEnum',
      dict[SomeEnum::class => '\\'.static::class.'::assertEnum'],
    );
    $ch->createMethod<?SomeEnum>(
      'nullableEnum',
      dict[SomeEnum::class => '\\'.static::class.'::assertEnum'],
    );
    $ch->createMethod<keyset<SomeEnum>>(
      'keysetOfSomeEnum',
      dict[SomeEnum::class => '\\'.static::class.'::assertEnum'],
    );
  }

  public function test_throws_when_no_enum_handler_was_provided(
  )[defaults]: void {
    expect_invoked(
      () ==> StaticTypeAssertionCodegen\from_type<SomeEnum>(dict[], panic<>),
    )
      ->toHaveThrown<InvariantException>(
        'Support for enums must be added using a $type_alias_asserters entry',
      );
  }

  public function test_uses_user_provided_asserters()[defaults]: void {
    static::okayValues<SomeEnum>(
      EnumTestCodegenTargetClass::someEnum<>,
      dict['member of SomeEnum' => SomeEnum::ONE],
    );
  }

  public function test_nullable_enums()[defaults]: void {
    static::okayValues<?SomeEnum>(
      EnumTestCodegenTargetClass::nullableEnum<>,
      dict['member of SomeEnum' => SomeEnum::ONE, 'null' => null],
    );
  }

  public function test_can_be_used_as_an_arraykey()[defaults]: void {
    static::okayValues<keyset<SomeEnum>>(
      EnumTestCodegenTargetClass::keysetOfSomeEnum<>,
      dict[
        'empty keyset' => keyset[],
        'keyset of SomeEnum' => keyset[SomeEnum::ONE],
      ],
    );
  }

  public static function assertEnum(mixed $m)[]: SomeEnum {
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
