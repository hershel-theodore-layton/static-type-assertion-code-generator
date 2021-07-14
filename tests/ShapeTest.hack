/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

final class ShapeTest extends HackTest {
  use TestHelpers;

  <<__Override>>
  public static async function beforeFirstTestAsync(): Awaitable<void> {
    using $ch = static::newCodegenHelper();
    $ch->createMethod<shape()>('emptyShape', 'shape()');
    $ch->createMethod<shape(...)>('emptyShapeWithExtraFields', 'shape(...)');
    $ch->createMethod<shape('a' => ?int)>(
      'shapeAToNullableInt',
      "shape('a' => ?int)",
    );
    $ch->createMethod<shape(?'a' => int)>(
      'shapeOptionalAToInt',
      "shape(?'a' => int)",
    );
    $ch->createMethod<?shape(?'a' => ?int, ...)>(
      'nullableShapeOptionalAToNullableIntWithExtraFields',
      "?shape(?'a' => ?int, ...)",
    );
    $ch->createMethod<shape(?'a' => vec<int>)>(
      'shapeOptionalAVecOfInt',
      "shape(?'a' => vec<int>)",
    );
    $ch->createMethod<shape(?'a' => vec<int>, 'b' => string, ...)>(
      'shapeOptionalAVecOfIntBStringWithExtraFields',
      "shape(?'a' => vec<int>, 'b' => string, ...)",
    );
    $ch->createMethod<shape('☃' => vec<string>)>(
      'shapeWithUnicodeKey',
      "shape('☃' => vec<string>)",
    );
  }

  public function test_okay_values(): void {
    static::okayValues<shape()>(
      $x ==> ShapeTestCodegenTargetClass::emptyShape($x),
      dict['empty shape' => shape()],
    );
    static::okayValues<shape(...)>(
      $x ==> ShapeTestCodegenTargetClass::emptyShapeWithExtraFields($x),
      dict[
        'empty shape' => shape(),
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::okayValues<shape('a' => ?int)>(
      $x ==> ShapeTestCodegenTargetClass::shapeAToNullableInt($x),
      dict[
        'shape a to int' => shape('a' => 1),
        'shape a to null' => shape('a' => null),
      ],
    );
    static::okayValues<shape(?'a' => int)>(
      $x ==> ShapeTestCodegenTargetClass::shapeOptionalAToInt($x),
      dict[
        'empty shape' => shape(),
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::okayValues<?shape(?'a' => ?int, ...)>(
      $x ==>
        ShapeTestCodegenTargetClass::nullableShapeOptionalAToNullableIntWithExtraFields(
          $x,
        ),
      dict[
        'null' => null,
        'empty shape' => shape(),
        'shape b to string' => shape('b' => 'a'),
        'shape a to null b to string' => shape('a' => null, 'b' => 'a'),
      ],
    );
    static::okayValues<shape(?'a' => vec<int>)>(
      $x ==> ShapeTestCodegenTargetClass::shapeOptionalAVecOfInt($x),
      dict[
        'empty shape' => shape(),
        'shape a empty vec' => shape('a' => vec[]),
        'shape a vec of int' => shape('a' => vec[1, 2, 3]),
      ],
    );
    static::okayValues<shape(?'a' => vec<int>, ...)>(
      $x ==>
        ShapeTestCodegenTargetClass::shapeOptionalAVecOfIntBStringWithExtraFields(
          $x,
        ),
      dict[
        'shape b string c string' => shape('b' => 'a', 'c' => 'extra'),
        'shape a empty vec' => shape('a' => vec[], 'b' => 'a'),
        'shape a vec of int b string' => shape('a' => vec[1, 2, 3], 'b' => 'a'),
      ],
    );
    static::okayValues<shape('☃' => vec<string>)>(
      $x ==> ShapeTestCodegenTargetClass::shapeWithUnicodeKey($x),
      dict[
        'shape with unicode key' =>
          shape('☃' => vec['we handled this character correctly in codegen']),
      ],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      $x ==> ShapeTestCodegenTargetClass::emptyShape($x),
      dict[
        'not a shape' => vec[],
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::badValues(
      $x ==> ShapeTestCodegenTargetClass::emptyShapeWithExtraFields($x),
      dict['not a shape' => vec[]],
    );
    static::badValues(
      $x ==> ShapeTestCodegenTargetClass::shapeAToNullableInt($x),
      dict['empty shape' => shape()],
    );
    static::badValues(
      $x ==> ShapeTestCodegenTargetClass::shapeOptionalAToInt($x),
      dict['shape a to null' => shape('a' => null)],
    );
    static::badValues(
      $x ==> ShapeTestCodegenTargetClass::shapeWithUnicodeKey($x),
      dict[
        'shape with wrong unicode character' =>
          shape('❄' => '❄ is not ☃'),
      ],
    );
  }

  public function test_effient_code(): void {
    static::bodyOfMethodOughtToBe('emptyShape', '__SEED__ as shape()');
    static::bodyOfMethodOughtToBe(
      'emptyShapeWithExtraFields',
      '__SEED__ as shape(...)',
    );
    static::bodyOfMethodOughtToBe(
      'nullableShapeOptionalAToNullableIntWithExtraFields',
      "__SEED__ as ?shape(?'a' => ?int, ...)",
      // This is still enforceable in one go.
    );

    static::bodyOfMethodOughtToBe(
      'shapeOptionalAVecOfIntBStringWithExtraFields',
      // hackfmt-ignore
      '() ==> { '.
        '$partial = __SEED__ as shape(?\'a\' => mixed, \'b\' => string, ...); '.
      //                 no need to assert here ^^^^^
      //        we can assert here, so we won't have to copy it ^^^^^^, unlike tuples, which we always copy
        'if (Shapes::keyExists($partial, \'a\')) { '.
          '$partial[\'a\'] = () ==> { '.
            '$out = vec[]; '.
            'foreach (($partial[\'a\'] as vec<_>) as $v) { '.
              '$out[] = $v as int; '.
            '} '.
            'return $out; '.
          '}(); '.
        '} else { '.
          'Shapes::removeKey(inout $partial, \'a\'); '.
      // Hack does not trust this code without the removeKey call.
      // The only way to get to the else is when 'a' is not present.
        '} '.
        'return $partial; '.
      '}()',
    );
  }
}
