/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

<<TestChain\Discover>>
function keyset_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('KeysetTest');
  $ch->createMethod<keyset<string>>('keysetOfString');
  $ch->createMethod<keyset<arraykey>>('keysetOfArrayKey');

  return $chain->group(__FUNCTION__)
    ->test('test_okay_values', () ==> {
      $helper->okayValues<keyset<string>>(
        KeysetTestCodegenTargetClass::keysetOfString<>,
        dict[
          'empty keyset' => keyset[],
          'keyset of string' => keyset['a', 'b', 'c'],
        ],
      );
    })
    ->test('test_bad_values', () ==> {
      $helper->badValues(
        KeysetTestCodegenTargetClass::keysetOfString<>,
        dict[
          'not a keyset' => dict[],
          'keyset of int' => keyset[1, 2, 3],
        ],
      );
    })
    ->test('test_effient_code', () ==> {
      $helper->bodyOfMethodOughtToBe(
        'keysetOfArrayKey',
        'return __SEED__ as keyset<_>;',
      );
    });
}
