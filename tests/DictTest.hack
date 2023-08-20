/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class DictTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<dict<int, bool>>('dictIntToBool', 'dict<int, bool>');
    $ch->createMethod<dict<arraykey, bool>>(
      'dictArraykeyToBool',
      'dict<arraykey, bool>',
    );
    $ch->createMethod<dict<string, mixed>>(
      'dictStringToMixed',
      'dict<string, mixed>',
    );
    $ch->createMethod<dict<arraykey, mixed>>(
      'dictArraykeyToMixed',
      'dict<arraykey, mixed>',
    );
  }

  public function test_okay_values(): void {
    static::okayValues<dict<int, bool>>(
      DictTestCodegenTargetClass::dictIntToBool<>,
      dict[
        'empty dict' => dict[],
        'dict of int to bool' => dict[5 => true, 2 => false],
      ],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      DictTestCodegenTargetClass::dictIntToBool<>,
      dict[
        'not a dict' => vec[],
        'dict of string to bool' => dict['string' => false],
        'dict of intish string to bool' => dict['5' => true],
        'dict of int to int' => dict[1 => 1],
      ],
    );
  }

  public function test_effient_code(): void {
    static::bodyOfMethodOughtToBe(
      'dictArraykeyToBool',
      '$out = dict[]; foreach ((__SEED__ as dict<_, _>) as $k => $v) { $out[$k] = $v as bool; } return $out;',
      //   no validation here, since arraykey does not need to be validated ^^
    );
    static::bodyOfMethodOughtToBe(
      'dictStringToMixed',
      '$out = dict[]; foreach ((__SEED__ as dict<_, _>) as $k => $v) { $out[$k as string] = $v; } return $out;',
      //                      no validation here, since mixed does not need to be validated ^^
    );
    static::bodyOfMethodOughtToBe(
      'dictArraykeyToMixed',
      'return __SEED__ as dict<_, _>;',
    );
  }
}
