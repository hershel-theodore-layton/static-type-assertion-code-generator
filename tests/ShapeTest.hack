/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

type ExampleShape = shape('the_expected_name' => int/*_*/);
final class ShapeTest {
  const string A = 'a';
  const string B = 'b';
  const string ALSO_A = 'a';
}

<<TestChain\Discover>>
function shape_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();

  using $ch = $helper->newCodegenHelper('ShapeTest');
  $ch->createMethod<shape(/*_*/)>('emptyShape');
  $ch->createMethod<shape(...)>('emptyShapeWithExtraFields');
  $ch->createMethod<shape('a' => ?int/*_*/)>('shapeAToNullableInt');
  $ch->createMethod<shape(?'a' => int/*_*/)>('shapeOptionalAToInt');
  $ch->createMethod<?shape(?'a' => ?int, ...)>(
    'nullableShapeOptionalAToNullableIntWithExtraFields',
  );
  $ch->createMethod<shape(?'a' => vec<int>/*_*/)>('shapeOptionalAVecOfInt');
  $ch->createMethod<shape(?'a' => vec<int>, 'b' => string, ...)>(
    'shapeOptionalAVecOfIntBStringWithExtraFields',
  );
  $ch->createMethod<shape('☃' => vec<string>/*_*/)>('shapeWithUnicodeKey');
  $ch->createMethod<shape('\'' => vec<string>/*_*/)>('shapeWithQuoteInKey');
  $ch->createMethod<
    shape(ShapeTest::A => int, ShapeTest::ALSO_A => string/*_*/),
  >('collidingKeys', dict[], ($_, $_)[] ==> 'ShapeTest::ALSO_A');
  $ch->createMethod<ExampleShape>(
    'testingArgumentsPassedToTheFieldResolver',
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

  return $chain->group(__FUNCTION__)
    ->test('test_okay_values', () ==> {
      $helper->okayValues<shape(/*_*/)>(
        ShapeTestCodegenTargetClass::emptyShape<>,
        dict['empty shape' => shape()],
      );
      $helper->okayValues<shape(...)>(
        ShapeTestCodegenTargetClass::emptyShapeWithExtraFields<>,
        dict[
          'empty shape' => shape(),
          'shape a to int' => shape('a' => 1),
        ],
      );
      $helper->okayValues<shape('a' => ?int/*_*/)>(
        ShapeTestCodegenTargetClass::shapeAToNullableInt<>,
        dict[
          'shape a to int' => shape('a' => 1),
          'shape a to null' => shape('a' => null),
        ],
      );
      $helper->okayValues<shape(?'a' => int/*_*/)>(
        ShapeTestCodegenTargetClass::shapeOptionalAToInt<>,
        dict[
          'empty shape' => shape(),
          'shape a to int' => shape('a' => 1),
        ],
      );
      $helper->okayValues<?shape(?'a' => ?int, ...)>(
        ShapeTestCodegenTargetClass::nullableShapeOptionalAToNullableIntWithExtraFields<>,
        dict[
          'null' => null,
          'empty shape' => shape(),
          'shape b to string' => shape('b' => 'a'),
          'shape a to null b to string' => shape('a' => null, 'b' => 'a'),
        ],
      );
      $helper->okayValues<shape(?'a' => vec<int>/*_*/)>(
        ShapeTestCodegenTargetClass::shapeOptionalAVecOfInt<>,
        dict[
          'empty shape' => shape(),
          'shape a empty vec' => shape('a' => vec[]),
          'shape a vec of int' => shape('a' => vec[1, 2, 3]),
        ],
      );
      $helper->okayValues<shape(?'a' => vec<int>, ...)>(
        ShapeTestCodegenTargetClass::shapeOptionalAVecOfIntBStringWithExtraFields<>,
        dict[
          'shape b string c string' => shape('b' => 'a', 'c' => 'extra'),
          'shape a empty vec' => shape('a' => vec[], 'b' => 'a'),
          'shape a vec of int b string' =>
            shape('a' => vec[1, 2, 3], 'b' => 'a'),
        ],
      );
      $helper->okayValues<shape('☃' => vec<string>/*_*/)>(
        ShapeTestCodegenTargetClass::shapeWithUnicodeKey<>,
        dict[
          'shape with unicode key' => shape(
            '☃' => vec['we handled this character correctly in codegen'],
          ),
        ],
      );

      $helper->okayValues<shape('\'' => vec<string>/*_*/)>(
        ShapeTestCodegenTargetClass::shapeWithQuoteInKey<>,
        dict[
          'shape with quote in key' => shape(
            '\'' => vec['we handled this character correctly in codegen'],
          ),
        ],
      );
    })
    ->test('test_bad_values', () ==> {
      $helper->badValues(
        ShapeTestCodegenTargetClass::emptyShape<>,
        dict[
          'not a shape' => vec[],
          'shape a to int' => shape('a' => 1),
        ],
      );
      $helper->badValues(
        ShapeTestCodegenTargetClass::emptyShapeWithExtraFields<>,
        dict['not a shape' => vec[]],
      );
      $helper->badValues(
        ShapeTestCodegenTargetClass::shapeAToNullableInt<>,
        dict['empty shape' => shape()],
      );
      $helper->badValues(
        ShapeTestCodegenTargetClass::shapeOptionalAToInt<>,
        dict['shape a to null' => shape('a' => null)],
      );
      $helper->badValues(
        ShapeTestCodegenTargetClass::shapeWithUnicodeKey<>,
        dict[
          'shape with wrong unicode character' =>
            shape('❄' => '❄ is not ☃'),
        ],
      );
    })
    ->test('test_colliding_keys', () ==> {
      // This is an hhvm bug.
      // We don't get the shape fields if the keys are duplicaites.
      // They are handed to us in a dict, which doesn't allow for duplicate keys.
      $helper->bodyOfMethodOughtToBe(
        'collidingKeys',
        'return __SEED__ as shape(ShapeTest::ALSO_A => string, /*_*/);',
      );
    })
    ->test('test_efficient_code', () ==> {
      $helper->bodyOfMethodOughtToBe(
        'emptyShape',
        'return __SEED__ as shape(/*_*/);',
      );
      $helper->bodyOfMethodOughtToBe(
        'emptyShapeWithExtraFields',
        'return __SEED__ as shape(...);',
      );
      $helper->bodyOfMethodOughtToBe(
        'nullableShapeOptionalAToNullableIntWithExtraFields',
        "return __SEED__ as ?shape(?'a' => ?int, ...);",
        // This is still enforceable in one go.
      );

      $helper->bodyOfMethodOughtToBe(
        'shapeOptionalAVecOfIntBStringWithExtraFields',
        // hackfmt-ignore
      '$out__1 = __SEED__ as shape(?\'a\' => mixed, \'b\' => string, ...); '.
      //               no need to assert here ^^^^^
      'if (Shapes::keyExists($out__1, \'a\')) { '.
        '$out__2 = vec[]; '.
        'foreach (($out__1[\'a\'] as vec<_>) as $v__2) { '.
          '$out__2[] = $v__2 as int; '.
        '} '.
        '$out__1[\'a\'] = $out__2; '.
      '} else { '.
        'Shapes::removeKey(inout $out__1, \'a\'); '.
        // Hack does not trust this code without the removeKey call.
        // The only way to get to the else is when 'a' is not present.
      '} '.
      'return $out__1;',
      );
    });
}
