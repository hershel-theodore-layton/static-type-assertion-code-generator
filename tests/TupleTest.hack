/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class TupleTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<(nonnull)>('tupleNonnull');
    $ch->createMethod<(null)>('tupleNull');
    $ch->createMethod<(mixed, mixed, mixed)>('tupleMixedMixedMixed');
    $ch->createMethod<(int, vec<int>, bool)>('tupleIntMixedVecOfIntBool');
    $ch->createMethod<(int, vec<mixed>, bool)>('tupleIntMixedVecOfMixedBool');
  }

  public function test_okay_values(): void {
    static::okayValues<(null)>(
      TupleTestCodegenTargetClass::tupleNull<>,
      dict['tuple null' => tuple(null)],
    );
    static::okayValues<(nonnull)>(
      TupleTestCodegenTargetClass::tupleNonnull<>,
      dict[
        'tuple int' => tuple(1),
        'tuple string' => tuple('a'),
        'tuple object' => tuple($this),
      ],
    );
    static::okayValues<(mixed, mixed, mixed)>(
      TupleTestCodegenTargetClass::tupleMixedMixedMixed<>,
      dict['tuple int string float' => tuple(1, 'a', 1.)],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      TupleTestCodegenTargetClass::tupleNull<>,
      dict[
        'not a tuple' => dict[],
        'wrong arity' => tuple(null, null),
        'tuple int' => tuple(1),
      ],
    );
  }

  public function test_effient_code(): void {
    static::bodyOfMethodOughtToBe(
      'tupleMixedMixedMixed',
      'return __SEED__ as (mixed, mixed, mixed);',
    );
    static::bodyOfMethodOughtToBe(
      'tupleIntMixedVecOfMixedBool',
      'return __SEED__ as (int, vec<_>, bool);',
      // enforceable vec<mixed>
    );
    static::bodyOfMethodOughtToBe(
      'tupleIntMixedVecOfIntBool',
      // Silly, and no value in fixing.         VV                                                                                        VV
      '$out__1 = __SEED__ as (int, mixed, bool);  $out__3 = vec[]; foreach (($out__1[1] as vec<_>) as $v__3) { $out__3[] = $v__3 as int; }  $out__1 = tuple($out__1[0], $out__3, $out__1[2]); return $out__1;',
      //  not used for `vec<_>`    ^^^^^ validate ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    );
  }
}
