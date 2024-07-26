/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class KeysetTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(
  )[defaults]: Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<keyset<string>>('keysetOfString');
    $ch->createMethod<keyset<arraykey>>('keysetOfArrayKey');
  }

  public function test_okay_values()[defaults]: void {
    static::okayValues<keyset<string>>(
      KeysetTestCodegenTargetClass::keysetOfString<>,
      dict[
        'empty keyset' => keyset[],
        'keyset of string' => keyset['a', 'b', 'c'],
      ],
    );
  }

  public function test_bad_values()[defaults]: void {
    static::badValues(
      KeysetTestCodegenTargetClass::keysetOfString<>,
      dict[
        'not a keyset' => dict[],
        'keyset of int' => keyset[1, 2, 3],
      ],
    );
  }

  public function test_effient_code()[defaults]: void {
    static::bodyOfMethodOughtToBe(
      'keysetOfArrayKey',
      'return __SEED__ as keyset<_>;',
    );
  }
}
