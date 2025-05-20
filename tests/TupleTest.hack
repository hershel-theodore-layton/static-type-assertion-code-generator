/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;
use type DateTime;

<<TestChain\Discover>>
function tuple_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('TupleTest');
  $ch->createMethod<(nonnull)>('tupleNonnull');
  $ch->createMethod<(null)>('tupleNull');
  $ch->createMethod<(mixed, mixed, mixed)>('tupleMixedMixedMixed');
  $ch->createMethod<(int, vec<int>, bool)>('tupleIntMixedVecOfIntBool');
  $ch->createMethod<(int, vec<mixed>, bool)>('tupleIntMixedVecOfMixedBool');

  return $chain->group(__FUNCTION__)
    ->test('test_okay_values', () ==> {
      $helper->okayValues<(null)>(
        TupleTestCodegenTargetClass::tupleNull<>,
        dict['tuple null' => tuple(null)],
      );
      $helper->okayValues<(nonnull)>(
        TupleTestCodegenTargetClass::tupleNonnull<>,
        dict[
          'tuple int' => tuple(1),
          'tuple string' => tuple('a'),
          'tuple object' => tuple(new DateTime()),
        ],
      );
      $helper->okayValues<(mixed, mixed, mixed)>(
        TupleTestCodegenTargetClass::tupleMixedMixedMixed<>,
        dict['tuple int string float' => tuple(1, 'a', 1.)],
      );
    })
    ->test('test_bad_values', () ==> {
      $helper->badValues(
        TupleTestCodegenTargetClass::tupleNull<>,
        dict[
          'not a tuple' => dict[],
          'wrong arity' => tuple(null, null),
          'tuple int' => tuple(1),
        ],
      );
    })
    ->test('test_effient_code', () ==> {
      $helper->bodyOfMethodOughtToBe(
        'tupleMixedMixedMixed',
        'return __SEED__ as (mixed, mixed, mixed);',
      );
      $helper->bodyOfMethodOughtToBe(
        'tupleIntMixedVecOfMixedBool',
        'return __SEED__ as (int, vec<_>, bool);',
        // enforceable vec<mixed>
      );
      $helper->bodyOfMethodOughtToBe(
        'tupleIntMixedVecOfIntBool',
        '$out__1 = __SEED__ as (int, mixed, bool); $out__3 = vec[]; foreach (($out__1[1] as vec<_>) as $v__3) { $out__3[] = $v__3 as int; } $out__1 = tuple($out__1[0], $out__3, $out__1[2]); return $out__1;',
        //  not used for `vec<_>`    ^^^^^ validate ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      );
    });
}
