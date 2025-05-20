/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

<<TestChain\Discover>>
function vec_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('VecTest');
  $ch->createMethod<vec<num>>('vecOfNum');
  $ch->createMethod<vec<mixed>>('vecOfMixed');

  return $chain->group(__FUNCTION__)
    ->test('test_okay_values', () ==> {
      $helper->okayValues<vec<num>>(
        VecTestCodegenTargetClass::vecOfNum<>,
        dict[
          'empty vec' => vec[],
          'vec of int' => vec[1, 2, 3, 4, 5],
          'vec of float' => vec[1., 2., 3., 4., 5.],
          'vec of num' => vec[1., 2, 3., 4, 5.],
        ],
      );
    })
    ->test('test_bad_values', () ==> {
      $helper->badValues(
        VecTestCodegenTargetClass::vecOfNum<>,
        dict[
          'not a vec' => dict[],
          'vec of string' => vec['a', 'b', 'c'],
          'vec of intish string' => vec['1', '2', '3'],
        ],
      );
    })
    ->test('test_effient_code', () ==> {
      $helper->bodyOfMethodOughtToBe(
        'vecOfMixed',
        'return __SEED__ as vec<_>;',
      );
    });
}
