/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class VecTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<vec<num>>('vecOfNum');
    $ch->createMethod<vec<mixed>>('vecOfMixed');
  }

  public function test_okay_values(): void {
    static::okayValues<vec<num>>(
      VecTestCodegenTargetClass::vecOfNum<>,
      dict[
        'empty vec' => vec[],
        'vec of int' => vec[1, 2, 3, 4, 5],
        'vec of float' => vec[1., 2., 3., 4., 5.],
        'vec of num' => vec[1., 2, 3., 4, 5.],
      ],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      VecTestCodegenTargetClass::vecOfNum<>,
      dict[
        'not a vec' => dict[],
        'vec of string' => vec['a', 'b', 'c'],
        'vec of intish string' => vec['1', '2', '3'],
      ],
    );
  }

  public function test_effient_code(): void {
    static::bodyOfMethodOughtToBe('vecOfMixed', 'return __SEED__ as vec<_>;');
  }
}
