/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

type HiddenInt = int;
type DeeplyNested = dict<int, (vec<shape('a' => vec<HiddenInt>/*_*/)>)>;

<<TestChain\Discover>>
async function statement_test_async(
  TestChain\Chain $chain,
)[defaults]: Awaitable<TestChain\Chain> {
  $helper = new TestHelpers();

  await using $ch = $helper->newCodegenHelper('StatementTest');
  $ch->createMethod<dict<int, vec<int>>>('statementInDict');
  $ch->createMethod<shape('a' => vec<int>/*_*/)>('statementInShape');
  $ch->createMethod<(vec<int>)>('statementInTuple');
  $ch->createMethod<vec<vec<int>>>('statementInVec');
  $ch->createMethod<DeeplyNested>(
    'deeplyNestedStatement',
    dict[(string)HiddenInt::class => 'hidden_int'],
  );

  return $chain->group(__FUNCTION__);
}

function hidden_int(mixed $mixed)[]: HiddenInt {
  return $mixed as int;
}
