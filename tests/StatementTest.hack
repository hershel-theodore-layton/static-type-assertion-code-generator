/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

type HiddenInt = int;
type DeeplyNested = dict<int, (vec<shape('a' => vec<HiddenInt>/*_*/)>)>;

final class StatementTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(
  )[defaults]: Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<dict<int, vec<int>>>('statementInDict');
    $ch->createMethod<shape('a' => vec<int>/*_*/)>('statementInShape');
    $ch->createMethod<(vec<int>)>('statementInTuple');
    $ch->createMethod<vec<vec<int>>>('statementInVec');
    $ch->createMethod<DeeplyNested>(
      'deeplyNestedStatement',
      dict[HiddenInt::class => '\\'.StatementTest::class.'::hiddenInt'],
    );
  }

  public static function hiddenInt(mixed $mixed)[]: HiddenInt {
    return $mixed as int;
  }
}
