/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class TupleTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<(nonnull)>('tupleNonnull', '(nonnull)');
    $ch->createMethod<(null)>('tupleNull', '(null)');
    $ch->createMethod<(mixed, mixed, mixed)>(
      'tupleMixedMixedMixed',
      '(mixed, mixed, mixed)',
    );
    $ch->createMethod<(int, vec<int>, bool)>(
      'tupleIntMixedVecOfIntBool',
      '(int, vec<int>, bool)',
    );
    $ch->createMethod<(int, vec<mixed>, bool)>(
      'tupleIntMixedVecOfMixedBool',
      '(int, vec<mixed>, bool)',
    );
  }

  public function test_okay_values(): void {
    static::okayValues<(null)>(
      $x ==> TupleTestCodegenTargetClass::tupleNull($x),
      dict['tuple null' => tuple(null)],
    );
    static::okayValues<(nonnull)>(
      $x ==> TupleTestCodegenTargetClass::tupleNonnull($x),
      dict[
        'tuple int' => tuple(1),
        'tuple string' => tuple('a'),
        'tuple object' => tuple($this),
      ],
    );
    static::okayValues<(mixed, mixed, mixed)>(
      $x ==> TupleTestCodegenTargetClass::tupleMixedMixedMixed($x),
      dict['tuple int string float' => tuple(1, 'a', 1.)],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      $x ==> TupleTestCodegenTargetClass::tupleNull($x),
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
