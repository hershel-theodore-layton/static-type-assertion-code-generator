/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\Str;
use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use function HTL\Expect\{expect, expect_invoked};

type TIntAlias = int;
newtype TOpaqueIntAsInt as int = int;
newtype TNullableOpaqueIntAsNullableInt as ?int = ?int;
newtype TOpaqueInt = int;
type TVecOfIntAlias = vec<int>;
newtype TOpaqueVecOfIntAsVecOfInt as vec<int> = vec<int>;
newtype TOpaqueVecOfInt = vec<int>;
newtype TNullable = ?string;
type TNullableShape = ?shape('a' => int, ...);

<<TestChain\Discover>>
function newtype_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('NewtypeTest');
  $ch->createMethod<dict<TOpaqueIntAsInt, TOpaqueIntAsInt>>(
    'opaquenessUsingUserResolvedFunctions',
    dict[
      TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );
  $ch->createMethod<TNullable>(
    'nullIsPassedToInherentlyNullableUserFunction',
    dict[
      TNullable::class => 'assert_nullable_with_sentinal',
    ],
  );
  $ch->createMethod<?TNullable>(
    'nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable',
    dict[
      TNullable::class => 'assert_nullable_with_sentinal',
    ],
  );
  $ch->createMethod<TNullableShape>('foo');
  $ch->createMethod<keyset<TOpaqueIntAsInt>>(
    'keysetOfTOpaqueIntAsInt',
    dict[
      TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );
  $ch->createMethod<vec<?TOpaqueIntAsInt>>(
    'vecOfNullableTOpaqueIntAsInt',
    dict[
      TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );

  $ch->createMethod<vec<?TNullableOpaqueIntAsNullableInt>>(
    'vecOfNullableTNullableOpaqueIntAsNullableInt',
    dict[
      TNullableOpaqueIntAsNullableInt::class =>
        'assert_nullable_opaque_int_as_nullable_int',
    ],
  );

  return $chain->group(__FUNCTION__)
    ->test('test_throws_when_no_newtype_handler_was_provided', () ==> {
      expect_invoked(
        () ==>
          StaticTypeAssertionCodegen\from_type<TOpaqueInt>(dict[], panic<>),
      )
        ->toHaveThrown<InvariantException>(
          'This type is a newtype and no $type_alias_asserters entry was provided.',
        );
    })
    ->test('test_uses_user_provided_asserters', () ==> {
      $helper->okayValues<dict<TOpaqueIntAsInt, TOpaqueIntAsInt>>(
        NewtypeTestCodegenTargetClass::opaquenessUsingUserResolvedFunctions<>,
        dict[
          'empty dict' => dict[],
          'dict TOpaqueIntAsInt to TOpaqueIntAsInt' => dict[123 => 456],
        ],
      );

      $helper->badValues(
        NewtypeTestCodegenTargetClass::opaquenessUsingUserResolvedFunctions<>,
        dict[
          'dict int to TOpaqueIntAsInt' => dict[-123 => 456],
          'dict TOpaqueIntAsInt to int' => dict[123 => -456],
        ],
      );
    })
    ->test(
      'test_user_provided_functions_for_inherently_nullable_types_are_invoked_with_null',
      () ==> {
        $sentinal =
          NewtypeTestCodegenTargetClass::nullIsPassedToInherentlyNullableUserFunction(
            null,
          );
        expect($sentinal)->toEqual('sentinal');

        $sentinal =
          NewtypeTestCodegenTargetClass::nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable(
            null,
          );
        expect($sentinal)->toEqual('sentinal');
      },
    )
    ->test(
      'test_types_backend_by_arraykeys_can_be_used_as_an_arraykey',
      () ==> {
        $helper->okayValues<keyset<TOpaqueIntAsInt>>(
          NewtypeTestCodegenTargetClass::keysetOfTOpaqueIntAsInt<>,
          dict[
            'empty keyset' => keyset[],
            'keyset of TOpaqueIntAsInt' => keyset[6],
          ],
        );
      },
    )
    ->test('test_a_nullable_newtype_is_guarded_from_nulls', () ==> {
      $helper->okayValues<vec<?TOpaqueInt>>(
        NewtypeTestCodegenTargetClass::vecOfNullableTOpaqueIntAsInt<>,
        dict['null' => vec[null], 'int' => vec[6]],
      );
    })
    ->test(
      'test_if_this_test_fails_you_can_remove_the_cleaning_opaque_reflection_hack',
      () ==> {
        // This reflection hack has since been moved to the HTL\TypeVisitor repo.
        expect(
          Shapes::idx(
            \HH\ReifiedGenerics\get_type_structure<TOpaqueVecOfIntAsVecOfInt>(),
            'opaque',
            '<missing>',
          ),
        )->toEqual('<missing>');
        expect(
          Shapes::idx(
            \HH\ReifiedGenerics\get_type_structure<TOpaqueVecOfInt>(),
            'opaque',
            '<missing>',
          ),
        )->toEqual('<missing>');
      },
    );
}

function assert_opaque_int_as_int(mixed $mixed)[]: TOpaqueIntAsInt {
  if (($mixed as int) < 0) {
    throw new \TypeAssertionException(
      Str\format(
        'Expected a %s, got a negative integer',
        TOpaqueIntAsInt::class,
      ),
    );
  }
  return $mixed;
}

function assert_nullable_opaque_int_as_nullable_int(
  mixed $mixed,
)[]: TNullableOpaqueIntAsNullableInt {
  return $mixed is null ? $mixed : assert_opaque_int_as_int($mixed);
}

function assert_nullable_with_sentinal(mixed $mixed)[]: TNullable {
  return $mixed is null ? 'sentinal' : $mixed as string;
}
