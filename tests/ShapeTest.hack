/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\HackTest;

type ExampleShape = shape('the_expected_name' => int);

final class ShapeTest extends HackTest {
  use TestHelpers;

  const string A = 'a';
  const string B = 'b';
  const string ALSO_A = 'a';

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
    $ch->createMethod<shape('\'' => vec<string>)>(
      'shapeWithQuoteInKey',
      "shape('\'' => vec<string>)",
    );
    $ch->createMethod<shape(ShapeTest::A => int, ShapeTest::ALSO_A => string)>(
      'collidingKeys',
      'shape(ShapeTest::ALSO_A => string)',
      dict[],
      ($_, $_)[] ==> 'ShapeTest::ALSO_A',
    );
    $ch->createMethod<ExampleShape>(
      'testingArgumentsPassedToTheFieldResolver',
      'ExampleShape',
      dict[],
      ($shape, $field)[] ==> {
        invariant(
          $shape === (string)ExampleShape::class,
          'Parent alias unexpected: %s',
          $shape,
        );
        invariant(
          $field === 'the_expected_name',
          'Field name unexpected: %s',
          $field,
        );

        return null;
      },
    );
  }

  public function test_okay_values(): void {
    static::okayValues<shape()>(
      ShapeTestCodegenTargetClass::emptyShape<>,
      dict['empty shape' => shape()],
    );
    static::okayValues<shape(...)>(
      ShapeTestCodegenTargetClass::emptyShapeWithExtraFields<>,
      dict[
        'empty shape' => shape(),
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::okayValues<shape('a' => ?int)>(
      ShapeTestCodegenTargetClass::shapeAToNullableInt<>,
      dict[
        'shape a to int' => shape('a' => 1),
        'shape a to null' => shape('a' => null),
      ],
    );
    static::okayValues<shape(?'a' => int)>(
      ShapeTestCodegenTargetClass::shapeOptionalAToInt<>,
      dict[
        'empty shape' => shape(),
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::okayValues<?shape(?'a' => ?int, ...)>(
      ShapeTestCodegenTargetClass::nullableShapeOptionalAToNullableIntWithExtraFields<>,
      dict[
        'null' => null,
        'empty shape' => shape(),
        'shape b to string' => shape('b' => 'a'),
        'shape a to null b to string' => shape('a' => null, 'b' => 'a'),
      ],
    );
    static::okayValues<shape(?'a' => vec<int>)>(
      ShapeTestCodegenTargetClass::shapeOptionalAVecOfInt<>,
      dict[
        'empty shape' => shape(),
        'shape a empty vec' => shape('a' => vec[]),
        'shape a vec of int' => shape('a' => vec[1, 2, 3]),
      ],
    );
    static::okayValues<shape(?'a' => vec<int>, ...)>(
      ShapeTestCodegenTargetClass::shapeOptionalAVecOfIntBStringWithExtraFields<>,
      dict[
        'shape b string c string' => shape('b' => 'a', 'c' => 'extra'),
        'shape a empty vec' => shape('a' => vec[], 'b' => 'a'),
        'shape a vec of int b string' => shape('a' => vec[1, 2, 3], 'b' => 'a'),
      ],
    );
    static::okayValues<shape('☃' => vec<string>)>(
      ShapeTestCodegenTargetClass::shapeWithUnicodeKey<>,
      dict[
        'shape with unicode key' =>
          shape('☃' => vec['we handled this character correctly in codegen']),
      ],
    );

    static::okayValues<shape('\'' => vec<string>)>(
      ShapeTestCodegenTargetClass::shapeWithQuoteInKey<>,
      dict[
        'shape with quote in key' => shape(
          '\'' => vec['we handled this character correctly in codegen'],
        ),
      ],
    );
  }

  public function test_bad_values(): void {
    static::badValues(
      ShapeTestCodegenTargetClass::emptyShape<>,
      dict[
        'not a shape' => vec[],
        'shape a to int' => shape('a' => 1),
      ],
    );
    static::badValues(
      ShapeTestCodegenTargetClass::emptyShapeWithExtraFields<>,
      dict['not a shape' => vec[]],
    );
    static::badValues(
      ShapeTestCodegenTargetClass::shapeAToNullableInt<>,
      dict['empty shape' => shape()],
    );
    static::badValues(
      ShapeTestCodegenTargetClass::shapeOptionalAToInt<>,
      dict['shape a to null' => shape('a' => null)],
    );
    static::badValues(
      ShapeTestCodegenTargetClass::shapeWithUnicodeKey<>,
      dict[
        'shape with wrong unicode character' =>
          shape('❄' => '❄ is not ☃'),
      ],
    );
  }

  public function test_colliding_keys(): void {
    // This is an hhvm bug.
    // We don't get the shape fields if the keys are duplicaites.
    // They are handed to us in a dict, which doesn't allow for duplicate keys.
    static::bodyOfMethodOughtToBe(
      'collidingKeys',
      'return __SEED__ as shape(ShapeTest::ALSO_A => string);',
    );
  }

  public function test_efficient_code(): void {
    static::bodyOfMethodOughtToBe('emptyShape', 'return __SEED__ as shape();');
    static::bodyOfMethodOughtToBe(
      'emptyShapeWithExtraFields',
      'return __SEED__ as shape(...);',
    );
    static::bodyOfMethodOughtToBe(
      'nullableShapeOptionalAToNullableIntWithExtraFields',
      "return __SEED__ as ?shape(?'a' => ?int, ...);",
      // This is still enforceable in one go.
    );

    static::bodyOfMethodOughtToBe(
      'shapeOptionalAVecOfIntBStringWithExtraFields',
      // hackfmt-ignore
      '$partial = __SEED__ as shape(?\'a\' => mixed, \'b\' => string, ...); '.
      //               no need to assert here ^^^^^
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
      'return $partial;',
    );
  }
}
