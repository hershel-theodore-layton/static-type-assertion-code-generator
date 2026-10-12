/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH;
use namespace HH\Lib\Str;
use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use type HTL\TypeVisitor\TAlias;
use function HTL\Expect\expect;

function resolve_box_asserter(TAlias $alias)[]: ?string {
  if ($alias['alias'] !== (string)TSpecializedBox::class) {
    return null;
  }
  $argument = idx($alias['typevar_types'] ?? dict[], 'T');
  if ($argument is null) {
    return null;
  }
  $type = $argument as dict<_, _>;
  switch ($type['kind'] ?? null) {
    case HH\TypeStructureKind::OF_INT:
      return ($type['nullable'] ?? false) === true
        ? 'assert_nullable_int_box'
        : 'assert_int_box';
    case HH\TypeStructureKind::OF_STRING:
      return 'assert_string_box';
    default:
      return null;
  }
}

<<TestChain\Discover>>
async function generic_alias_handler_test_async(
  TestChain\Chain $chain,
)[defaults]: Awaitable<TestChain\Chain> {
  $helper = new TestHelpers();
  await using $ch = $helper->newCodegenHelper('GenericAliasHandlerTest');
  // The resolver takes priority over a name-only registration.
  $table = dict[(string)TSpecializedBox::class => 'assert_int_box'];
  $ch->createMethod<TSpecializedPair>(
    'pair',
    $table,
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedPair',
    resolve_box_asserter<>,
  );
  $ch->createMethod<
    (TSpecializedBox<int>, TSpecializedBox<string>, TSpecializedBox<int>),
  >(
    'repeated',
    $table,
    null,
    '(\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedBox<int>, '.
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedBox<string>, '.
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedBox<int>)',
    resolve_box_asserter<>,
  );
  $ch->createMethod<TSpecializedNested>(
    'nested',
    $table,
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedNested',
    resolve_box_asserter<>,
  );
  $ch->createMethod<vec<TSpecializedBox<int>>>(
    'fallback',
    $table,
    null,
    'vec<\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedBox<int>>',
    ($_)[] ==> null,
  );
  $ch->createMethod<TSpecializedIntBox>(
    'transparent',
    $table,
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedIntBox',
    resolve_box_asserter<>,
  );
  $ch->createMethod<TSpecializedBox<?int>>(
    'nullableArgument',
    dict[],
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TSpecializedBox<?int>',
    resolve_box_asserter<>,
  );
  $ch->createMethod<?TGenericIdentity<?int>>(
    'nullable',
    dict[],
    null,
    '?\\HTL\\StaticTypeAssertionCodegen\\Tests\\TGenericIdentity<?int>',
    ($alias)[] ==> $alias['alias'] === (string)TGenericIdentity::class
      ? 'assert_generic_nullable_identity'
      : null,
  );
  return $chain->group(__FUNCTION__)
    ->test('specialize_composite_and_repeated_nested_aliases', () ==> {
      $pair = tuple(shape('value' => 7), shape('value' => 'seven'));
      $repeated = tuple($pair[0], $pair[1], $pair[0]);
      expect(GenericAliasHandlerTestCodegenTargetClass::repeated($repeated))
        ->toEqual($repeated);
      expect(GenericAliasHandlerTestCodegenTargetClass::pair($pair))
        ->toEqual($pair);
      expect(
        GenericAliasHandlerTestCodegenTargetClass::nested(vec[$pair, $pair]),
      )
        ->toEqual(vec[$pair, $pair]);
      $helper->badValues(
        GenericAliasHandlerTestCodegenTargetClass::repeated<>,
        dict[
          'wrong third field' =>
            tuple($pair[0], $pair[1], shape('value' => '7')),
        ],
      );
      $helper->badValues(
        GenericAliasHandlerTestCodegenTargetClass::pair<>,
        dict[
          'wrong first field' =>
            tuple(shape('value' => '7'), shape('value' => 'seven')),
          'wrong second field' =>
            tuple(shape('value' => 7), shape('value' => 7)),
        ],
      );
      $body = StaticTypeAssertionCodegen\from_type<TSpecializedPair>(
        $table,
        panic<>,
        null,
        shape(),
        resolve_box_asserter<>,
      )
        |> StaticTypeAssertionCodegen\emit_body_for_assertion_function($$);
      expect(Str\contains($body, 'assert_int_box('))->toEqual(true);
      expect(Str\contains($body, 'assert_string_box('))->toEqual(true);
    })
    ->test('resolver_null_falls_back_to_name_table', () ==> {
      expect(GenericAliasHandlerTestCodegenTargetClass::transparent(
        shape('value' => 7),
      ))
        ->toEqual(shape('value' => 7));
      $value = vec[shape('value' => 7)];
      expect(GenericAliasHandlerTestCodegenTargetClass::fallback($value))
        ->toEqual($value);
    })
    ->test('missing_metadata_can_fall_back_to_name_table', () ==> {
      $visitor = new StaticTypeAssertionCodegen\DefaultVisitor(
        dict[(string)TSpecializedBox::class => 'assert_int_box'],
        panic<>,
        ($_, $_)[] ==> null,
        shape(),
        resolve_box_asserter<>,
      );
      $description = $visitor->shape(
        shape(
          'alias' => (string)TSpecializedBox::class,
          'counter' => 1,
          'opaque' => true,
        ),
        vec[],
        false,
      );
      expect($description->emitAssertionExpression('$value'))
        ->toEqual('assert_int_box($value)');
    })
    ->test('resolved_handlers_keep_inherent_null_semantics', () ==> {
      expect(GenericAliasHandlerTestCodegenTargetClass::nullableArgument(
        shape('value' => null),
      ))
        ->toEqual(shape('value' => null));
      expect(GenericAliasHandlerTestCodegenTargetClass::nullableArgument(
        shape('value' => 7),
      ))
        ->toEqual(shape('value' => 7));
      expect(GenericAliasHandlerTestCodegenTargetClass::nullable(null))
        ->toEqual(41);
    });
}
