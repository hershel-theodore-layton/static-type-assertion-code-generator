/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;
use function HTL\Expect\expect_invoked;
use function HTL\StaticTypeAssertionCodegen\from_type;

final class VecOrDictTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(
  )[defaults]: Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<vec_or_dict<mixed>>('topTypeOneGeneric');
    $ch->createMethod<vec_or_dict<arraykey, mixed>>('topTypeTwoGenerics');
    $ch->createMethod<vec_or_dict<int, mixed>>('intKeyed');
    $ch->createMethod<vec_or_dict<keyset<string>>>('validateValue');
    $ch->createMethod<vec_or_dict<int, keyset<string>>>('validateKeyAndValue');
  }

  public function test_bad_input()[defaults]: void {
    expect_invoked(() ==> from_type<vec_or_dict<string, int>>(dict[], panic<>))
      ->toHaveThrown<InvariantException>('EXACTLY arraykey or int');
  }

  public function test_okay_values()[defaults]: void {
    static::okayValues<vec_or_dict<int, keyset<string>>>(
      VecOrDictTestCodegenTargetClass::validateKeyAndValue<>,
      dict[
        'if the input is a vec, the output is a vec' => vec[],
        'if the input is a dict, the output is a dict' => dict[],
        'the keys of a dict are retained' => dict[5 => keyset['string']],
      ],
    );
  }

  public function test_bad_values()[defaults]: void {
    static::badValues(
      VecOrDictTestCodegenTargetClass::validateKeyAndValue<>,
      dict[
        'value type is wrong' => vec['not a keyset'],
        'key type is wrong' => dict['not an int' => keyset[]],
        'input is not a dict or vec' => keyset[],
      ],
    );
  }

  public function test_effient_code()[defaults]: void {
    static::bodyOfMethodOughtToBe(
      'topTypeOneGeneric',
      'return __SEED__ as vec_or_dict<_>;',
    );
    static::bodyOfMethodOughtToBe(
      'topTypeTwoGenerics',
      'return __SEED__ as vec_or_dict<_>;',
    );
    //hackfmt-ignore
    static::bodyOfMethodOughtToBe(
      'intKeyed',
      '$out__1 = dict[]; '.
      'foreach ((__SEED__ as vec_or_dict<_>) as $k__1 => $v__1) { '.
        '$out__1[$k__1 as int] = $v__1; '.
      '} '.
      '$out__1 = __SEED__ is vec<_> '.
        '? vec($out__1) '.
        ': $out__1; return $out__1;',
    );

    //hackfmt-ignore
    static::bodyOfMethodOughtToBe(
      'validateValue',
      '$out__1 = dict[]; '.
      'foreach ((__SEED__ as vec_or_dict<_>) as $k__1 => $v__1) { '.
        '$out__2 = keyset[]; '.
        'foreach (($v__1 as keyset<_>) as $k__2) { '.
          '$out__2[] = $k__2 as string; '.
        '} '.
        '$out__1[$k__1] = $out__2; '.
      '} '.
      '$out__1 = __SEED__ is vec<_> '.
        '? vec($out__1) '.
        ': $out__1; return $out__1;',
    );
  }
}
