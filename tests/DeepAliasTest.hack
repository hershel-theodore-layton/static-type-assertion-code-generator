/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HTL\TestChain;

type TLevel1 = int;
type TLevel2 = TLevel1;
type TLevel3 = TLevel2;
type TLevel4 = TLevel3;
type TLevel5 = TLevel4;

newtype YesNo = bool;
type MaybeYesNo = ?YesNo;

<<TestChain\Discover>>
function deep_alias_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('DeepAliasTest');
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

  return $chain->group(__FUNCTION__)
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

function level_1_and_2(mixed $mixed)[]: TLevel1 {
  return $mixed as int;
}

function level_3_and_4_and_5(mixed $mixed)[]: TLevel1 {
  return $mixed as int;
}

function yes_no(mixed $mixed)[]: YesNo {
  return $mixed as bool;
}
