/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

type HiddenInt = int;
type DeeplyNested = dict<int, (vec<shape('a' => vec<HiddenInt>/*_*/)>)>;

<<TestChain\Discover>>
function statement_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();

  using $ch = $helper->newCodegenHelper('StatementTest');
  $ch->createMethod<dict<int, vec<int>>>('statementInDict');
  $ch->createMethod<shape('a' => vec<int>/*_*/)>('statementInShape');
  $ch->createMethod<(vec<int>)>('statementInTuple');
  $ch->createMethod<vec<vec<int>>>('statementInVec');
  $ch->createMethod<DeeplyNested>(
    'deeplyNestedStatement',
    dict[HiddenInt::class => 'hidden_int'],
  );

  return $chain->group(__FUNCTION__);
}

function hidden_int(mixed $mixed)[]: HiddenInt {
  return $mixed as int;
}
