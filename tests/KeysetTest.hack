/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class KeysetTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<keyset<string>>('keysetOfString', 'keyset<string>');
    $ch->createMethod<keyset<arraykey>>('keysetOfArrayKey', 'keyset<arraykey>');
  }

  public function test_okay_values(): void {
    static::okayValues<keyset<string>>(
      $x ==> KeysetTestCodegenTargetClass::keysetOfString($x),
      dict[
        'empty keyset' => keyset[],
        'keyset of string' => keyset['a', 'b', 'c'],
      ],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      $x ==> KeysetTestCodegenTargetClass::keysetOfString($x),
      dict[
        'not a keyset' => dict[],
        'keyset of int' => keyset[1, 2, 3],
      ],
    );
  }

  public function test_effient_code(): void {
    static::bodyOfMethodOughtToBe('keysetOfArrayKey', '__SEED__ as keyset<_>');
  }
}
