/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\Str;
use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use type TypeAssertionException;
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
async function newtype_test_async(
  TestChain\Chain $chain,
)[defaults]: Awaitable<TestChain\Chain> {
  $helper = new TestHelpers();
  await using $ch = $helper->newCodegenHelper('NewtypeTest');
  $ch->createMethod<dict<TOpaqueIntAsInt, TOpaqueIntAsInt>>(
    'opaquenessUsingUserResolvedFunctions',
    dict[
      (string)TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );
  $ch->createMethod<TNullable>(
    'nullIsPassedToInherentlyNullableUserFunction',
    dict[
      (string)TNullable::class => 'assert_nullable_with_sentinal',
    ],
  );
  $ch->createMethod<?TNullable>(
    'nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable',
    dict[
      (string)TNullable::class => 'assert_nullable_with_sentinal',
    ],
  );
  $ch->createMethod<TNullableShape>('foo');
  $ch->createMethod<keyset<TOpaqueIntAsInt>>(
    'keysetOfTOpaqueIntAsInt',
    dict[
      (string)TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );
  $ch->createMethod<vec<?TOpaqueIntAsInt>>(
    'vecOfNullableTOpaqueIntAsInt',
    dict[
      (string)TOpaqueIntAsInt::class => 'assert_opaque_int_as_int',
    ],
  );

  $ch->createMethod<vec<?TNullableOpaqueIntAsNullableInt>>(
    'vecOfNullableTNullableOpaqueIntAsNullableInt',
    dict[
      (string)TNullableOpaqueIntAsNullableInt::class =>
        'assert_nullable_opaque_int_as_nullable_int',
    ],
  );

  $identity_handlers = dict[
    (string)TGenericIdentity::class => 'assert_generic_nullable_identity',
  ];
  $ch->createMethod<TGenericIdentity<?int>>(
    'genericNullableIdentity',
    $identity_handlers,
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericIdentity<?int>',
  );
  $ch->createMethod<?TGenericIdentity<?int>>(
    'redundantlyNullableGenericIdentity',
    $identity_handlers,
    null,
    '?\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericIdentity<?int>',
  );
  $ch->createMethod<?TGenericIdentity<int>>(
    'externallyNullableGenericIdentity',
    dict[(string)TGenericIdentity::class => 'assert_generic_identity'],
    null,
    '?\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericIdentity<int>',
  );
  $ch->createMethod<?TGenericIdentity<dynamic>>(
    'genericDynamicIdentity',
    dict[(string)TGenericIdentity::class => 'assert_generic_dynamic'],
    null,
    '?\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericIdentity<dynamic>',
  );
  $ch->createMethod<TGenericMaybe<int>>(
    'genericMaybe',
    dict[(string)TGenericMaybe::class => 'assert_generic_maybe'],
  );
  $ch->createMethod<TGenericNested<?int>>(
    'genericNested',
    dict[(string)TGenericNested::class => 'assert_generic_nested'],
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericNested<?int>',
  );
  $ch->createMethod<TGenericTransparent<?int>>(
    'genericTransparent',
    $identity_handlers,
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericTransparent<?int>',
  );

  $ch->createMethod<?TGenericTransparent<int>>(
    'externallyNullableGenericTransparent',
    dict[(string)TGenericIdentity::class => 'assert_generic_identity'],
  );
  $ch->createMethod<?TGenericVector<?int>>(
    'externallyNullableGenericVector',
    dict[(string)TGenericVector::class => 'assert_generic_vector'],
  );

  return $chain->group(__FUNCTION__)
    ->test('generic_handlers_receive_inherent_nulls', () ==> {
      expect(NewtypeTestCodegenTargetClass::genericNullableIdentity(null))
        ->toEqual(41);
      expect(
        NewtypeTestCodegenTargetClass::redundantlyNullableGenericIdentity(null),
      )
        ->toEqual(41);
      expect(NewtypeTestCodegenTargetClass::genericMaybe(null))->toEqual(42);
      expect(NewtypeTestCodegenTargetClass::genericDynamicIdentity(null))
        ->toEqual(43);
      expect(NewtypeTestCodegenTargetClass::genericNested(null))->toEqual(41);
      expect(NewtypeTestCodegenTargetClass::genericTransparent(null))->toEqual(
        41,
      );
      expect(NewtypeTestCodegenTargetClass::genericNullableIdentity(7))
        ->toEqual(7);
      expect(
        NewtypeTestCodegenTargetClass::externallyNullableGenericIdentity(null),
      )
        ->toEqual(null);
      expect(
        NewtypeTestCodegenTargetClass::externallyNullableGenericIdentity(7),
      )
        ->toEqual(7);
    })
    ->test('external_nulls_bypass_nonnullable_generic_handlers', () ==> {
      expect(
        NewtypeTestCodegenTargetClass::externallyNullableGenericTransparent(
          null,
        ),
      )
        ->toEqual(null);
      expect(
        NewtypeTestCodegenTargetClass::externallyNullableGenericTransparent(7),
      )
        ->toEqual(7);
      expect(
        NewtypeTestCodegenTargetClass::externallyNullableGenericVector(null),
      )
        ->toEqual(null);
      expect(NewtypeTestCodegenTargetClass::externallyNullableGenericVector(
        vec[null, 7],
      ))
        ->toEqual(vec[null, 7]);
    })
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
        $sentinel =
          NewtypeTestCodegenTargetClass::nullIsPassedToInherentlyNullableUserFunction(
            null,
          );
        expect($sentinel)->toEqual('sentinal');

        $sentinel =
          NewtypeTestCodegenTargetClass::nullIsPassedToInherentlyNullableUserFunctionEvenWhenRedundantlyNullable(
            null,
          );
        expect($sentinel)->toEqual('sentinal');
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
    });
}

function assert_opaque_int_as_int(mixed $mixed)[]: TOpaqueIntAsInt {
  if (($mixed as int) < 0) {
    throw new TypeAssertionException(
      Str\format(
        'Expected a %s, got a negative integer',
        (string)TOpaqueIntAsInt::class,
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
