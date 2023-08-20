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
      '$partial = __SEED__ as (int, mixed, bool); return tuple($partial[0], () ==> { $out = vec[]; foreach (($partial[1] as vec<_>) as $v) { $out[] = $v as int; } return $out; }(), $partial[2]);',
      //  mixed no use for `vec<_>` ^^^^^   validate here and copy the rest ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    );
  }
}
