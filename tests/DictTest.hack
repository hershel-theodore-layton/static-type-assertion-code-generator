/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

<<TestChain\Discover>>
function dict_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('DictTest');
  $ch->createMethod<dict<int, bool>>('dictIntToBool');
  $ch->createMethod<dict<arraykey, bool>>('dictArraykeyToBool');
  $ch->createMethod<dict<string, mixed>>('dictStringToMixed');
  $ch->createMethod<dict<arraykey, mixed>>('dictArraykeyToMixed');

  return $chain->group(__FUNCTION__)
    ->test('test_okay_values', () ==> {
      $helper->okayValues<dict<int, bool>>(
        DictTestCodegenTargetClass::dictIntToBool<>,
        dict[
          'empty dict' => dict[],
          'dict of int to bool' => dict[5 => true, 2 => false],
        ],
      );
    })
    ->test('test_bad_values', () ==> {
      $helper->badValues(
        DictTestCodegenTargetClass::dictIntToBool<>,
        dict[
          'not a dict' => vec[],
          'dict of string to bool' => dict['string' => false],
          'dict of intish string to bool' => dict['5' => true],
          'dict of int to int' => dict[1 => 1],
        ],
      );
    })
    ->test('test_effient_code', () ==> {
      $helper->bodyOfMethodOughtToBe(
        'dictArraykeyToBool',
        '$out__1 = dict[]; foreach ((__SEED__ as dict<_, _>) as $k__1 => $v__1) { $out__1[$k__1] = $v__1 as bool; } return $out__1;',
        //   no validation here, since arraykey does not need to be validated                          ^^^^^
      );
      $helper->bodyOfMethodOughtToBe(
        'dictStringToMixed',
        '$out__1 = dict[]; foreach ((__SEED__ as dict<_, _>) as $k__1 => $v__1) { $out__1[$k__1 as string] = $v__1; } return $out__1;',
        //                      no validation here, since mixed does not need to be validated                             ^^^^^
      );
      $helper->bodyOfMethodOughtToBe(
        'dictArraykeyToMixed',
        'return __SEED__ as dict<_, _>;',
      );
    });
}
