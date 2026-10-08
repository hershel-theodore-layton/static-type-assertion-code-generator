/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use function HTL\Expect\expect_invoked;

type TLevel1 = int;
type TLevel2 = TLevel1;
type TLevel3 = TLevel2;
type TLevel4 = TLevel3;
type TLevel5 = TLevel4;

newtype YesNo = bool;
type MaybeYesNo = ?YesNo;

<<TestChain\Discover>>
async function deep_alias_test_async(
  TestChain\Chain $chain,
)[defaults]: Awaitable<TestChain\Chain> {
  $helper = new TestHelpers();
  await using $ch = $helper->newCodegenHelper('DeepAliasTest');
  $ch->createMethod<TLevel1>(
    'level1',
    dict[
      (string)TLevel1::class => 'level_1_and_2',
    ],
  );

  $ch->createMethod<TLevel2>(
    'level2',
    dict[
      (string)TLevel1::class => 'level_1_and_2',
    ],
  );

  $ch->createMethod<TLevel3>(
    'level3',
    dict[
      (string)TLevel3::class => 'level_3_and_4_and_5',
    ],
  );

  $ch->createMethod<TLevel4>(
    'level4',
    dict[
      (string)TLevel3::class => 'level_3_and_4_and_5',
    ],
  );

  $ch->createMethod<TLevel5>(
    'level5',
    dict[
      (string)TLevel3::class => 'level_3_and_4_and_5',
    ],
  );

  $ch->createMethod<YesNo>('yesNo', dict[(string)YesNo::class => 'yes_no']);
  $ch->createMethod<MaybeYesNo>(
    'maybeYesNo',
    dict[(string)YesNo::class => 'yes_no'],
  );

  $outer_handlers = dict[
    (string)TBoundaryInner::class => 'assert_boundary_inner',
    (string)TBoundaryOuter::class => 'assert_boundary_outer',
  ];
  $ch->createMethod<TBoundaryOuter>('opaqueOuter', $outer_handlers);
  $ch->createMethod<TBoundaryTransparentOuter>(
    'transparentOuter',
    $outer_handlers,
  );
  $ch->createMethod<TBoundaryLongChain>('longChain', $outer_handlers);
  $ch->createMethod<TBoundaryNullableOuter>('nullableOuter', $outer_handlers);
  $ch->createMethod<TBoundaryOuterViaTransparent>(
    'opaqueOuterViaTransparent',
    dict[
      (string)TBoundaryOuterViaTransparent::class =>
        'assert_boundary_outer_via_transparent',
    ],
  );
  $ch->createMethod<TBoundaryNullable>(
    'nullableBoundary',
    dict[(string)TBoundaryNullable::class => 'assert_boundary_nullable'],
  );
  $ch->createMethod<TBoundaryTransparentInner>(
    'transparentInner',
    dict[(string)TBoundaryInner::class => 'assert_boundary_inner'],
  );

  return $chain->group(__FUNCTION__)
    ->test('require_a_handler_at_each_opaque_boundary', () ==> {
      expect_missing_boundary_handler<TBoundaryOuter>();
      expect_missing_boundary_handler<TBoundaryOuterViaTransparent>();
      expect_missing_boundary_handler<TBoundaryTransparentOuter>();
      expect_missing_boundary_handler<TBoundaryLongChain>();
      expect_missing_boundary_handler<TBoundaryNullableOuter>();
      expect_missing_boundary_handler<TBoundaryNullable>();
    })
    ->test('opaque_boundary_handlers_produce_typed_values', () ==> {
      $helper->okayValues<TBoundaryOuter>(
        DeepAliasTestCodegenTargetClass::opaqueOuter<>,
        dict['int' => assert_boundary_outer(7)],
      );
      $helper->okayValues<TBoundaryTransparentOuter>(
        DeepAliasTestCodegenTargetClass::transparentOuter<>,
        dict['int' => assert_boundary_outer(7)],
      );
      $helper->okayValues<TBoundaryLongChain>(
        DeepAliasTestCodegenTargetClass::longChain<>,
        dict['int' => assert_boundary_outer(7)],
      );
      $helper->okayValues<TBoundaryNullableOuter>(
        DeepAliasTestCodegenTargetClass::nullableOuter<>,
        dict['null' => null, 'int' => assert_boundary_outer(7)],
      );
      $helper->okayValues<TBoundaryOuterViaTransparent>(
        DeepAliasTestCodegenTargetClass::opaqueOuterViaTransparent<>,
        dict['int' => assert_boundary_outer_via_transparent(7)],
      );
      $helper->okayValues<TBoundaryNullable>(
        DeepAliasTestCodegenTargetClass::nullableBoundary<>,
        dict[
          'null' => assert_boundary_nullable(null),
          'int' => assert_boundary_nullable(7),
        ],
      );
      $helper->okayValues<TBoundaryTransparentInner>(
        DeepAliasTestCodegenTargetClass::transparentInner<>,
        dict['int' => assert_boundary_inner(7)],
      );
    })
    ->test('test_plain_alias', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'level1',
        'return level_1_and_2(__SEED__);',
      );
    })
    ->test('pop_until_type_alias_with_asserter', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'level2',
        'return level_1_and_2(__SEED__);',
      );
    })
    ->test('do_not_look_down_if_you_have_an_asserter', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'level3',
        'return level_3_and_4_and_5(__SEED__);',
      );
    })
    ->test('stop_halfway_if_that_is_where_you_encounter_the_first', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'level4',
        'return level_3_and_4_and_5(__SEED__);',
      );
    })
    ->test('can_follow_multiple_steps', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'level5',
        'return level_3_and_4_and_5(__SEED__);',
      );
    })
    ->test('assert_nonnullable_newtype', ()[] ==> {
      $helper->bodyOfMethodOughtToBe('yesNo', 'return yes_no(__SEED__);');
    })
    ->test('assert_nullable_alias_over_a_newtype', ()[] ==> {
      $helper->bodyOfMethodOughtToBe(
        'maybeYesNo',
        'if (__SEED__ is null) {'.
        ' $out__1 = null; '.
        '} else {'.
        '  $out__1 = yes_no(__SEED__);'.
        '}'.
        ' return $out__1;',
      );
    });
}

function expect_missing_boundary_handler<reify T>()[defaults]: void {
  expect_invoked(
    () ==> StaticTypeAssertionCodegen\from_type<T>(
      dict[(string)TBoundaryInner::class => 'assert_boundary_inner'],
      panic<>,
    ),
  )->toHaveThrown<InvariantException>(
    'This type is a newtype and no $type_alias_asserters entry was provided.',
  );
}

function level_1_and_2(mixed $mixed)[]: TLevel1 {
  return $mixed as int;
}

function level_3_and_4_and_5(mixed $mixed)[]: TLevel1 {
  return $mixed as int;
}

function yes_no(mixed $mixed)[]: YesNo {
  return $mixed as bool;
}
