/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH;
use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use type HTL\TypeVisitor\TAlias;
use type stdClass;
use function HTL\Expect\{expect, expect_invoked};

function resolver_lookup_body<reify T>(
  dict<string, string> $table,
  (function(TAlias, dict<string, string>)[]: ?string) $resolver,
)[]: string {
  return StaticTypeAssertionCodegen\from_type<T>(
    $table,
    panic<>,
    null,
    shape('assertion_resolver' => $resolver),
  )
    |> StaticTypeAssertionCodegen\emit_body_for_assertion_function($$);
}

function resolve_class_asserter(
  TAlias $alias,
  dict<string, string> $_,
)[]: ?string {
  return $alias['alias'] === 'stdClass' ? 'assert_resolver_class' : null;
}

function resolve_reflected_asserter(
  TAlias $alias,
  dict<string, string> $_,
)[]: ?string {
  if ($alias['alias'] === (string)TResolverInner::class) {
    expect($alias['opaque'])->toEqual(false);
    $type = idx($alias['typevar_types'] ?? dict[], 'TItem') as dict<_, _>;
    expect($type['kind'])->toEqual(HH\TypeStructureKind::OF_VEC);
    $arguments = $type['generic_types'] as vec<_>;
    expect(($arguments[0] as dict<_, _>)['kind'])
      ->toEqual(HH\TypeStructureKind::OF_INT);
    return 'assert_vector_int_box';
  }
  if ($alias['alias'] === (string)TGenericIdentity::class) {
    expect($alias['opaque'])->toEqual(true);
    $type = idx($alias['typevar_types'] ?? dict[], 'T') as dict<_, _>;
    expect($type['kind'])->toEqual(HH\TypeStructureKind::OF_INT);
    expect($type['nullable'])->toEqual(true);
    return 'assert_generic_nullable_identity';
  }
  return null;
}

<<TestChain\Discover>>
async function resolver_lookup_test_async(
  TestChain\Chain $chain,
)[defaults]: Awaitable<TestChain\Chain> {
  $helper = new TestHelpers();
  await using $ch = $helper->newCodegenHelper('ResolverLookupTest');
  $ch->createMethod<TResolverClassAlias>(
    'classAlias',
    dict['stdClass' => 'handler_that_must_not_be_selected'],
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TResolverClassAlias',
    resolve_class_asserter<>,
  );
  $ch->createMethod<TResolverOuter<int>>(
    'nestedArguments',
    dict[],
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TResolverOuter<int>',
    resolve_reflected_asserter<>,
  );
  $ch->createMethod<TResolverNullable<int>>(
    'nullableArgument',
    dict[],
    null,
    '\\HTL\\StaticTypeAssertionCodegen\\Tests\\TResolverNullable<int>',
    resolve_reflected_asserter<>,
  );
  return $chain->group(__FUNCTION__)
    ->test('specialize_before_each_alias_table_lookup', ()[] ==> {
      $table = dict[(string)TLevel3::class => 'level_1_and_2'];
      expect(resolver_lookup_body<TLevel5>(
        $table,
        ($alias, $_)[] ==> $alias['alias'] === (string)TLevel3::class
          ? 'level_3_and_4_and_5'
          : null,
      ))->toEqual('return level_3_and_4_and_5($htl_untyped_variable);');
      expect(resolver_lookup_body<TLevel5>($table, ($_, $_)[] ==> null))
        ->toEqual('return level_1_and_2($htl_untyped_variable);');
      expect(resolver_lookup_body<TLevel5>($table, ($alias, $_)[] ==> {
        expect($alias['alias'])->toEqual((string)TLevel5::class);
        return 'level_3_and_4_and_5';
      }))->toEqual('return level_3_and_4_and_5($htl_untyped_variable);');
    })
    ->test('specialize_the_underlying_class_before_its_table_entry', () ==> {
      $object = new stdClass();
      expect(ResolverLookupTestCodegenTargetClass::classAlias($object))
        ->toEqual($object);
      expect(resolver_lookup_body<stdClass>(dict[], resolve_class_asserter<>))
        ->toEqual('return assert_resolver_class($htl_untyped_variable);');
    })
    ->test('preserve_reflected_arguments_and_nullability', () ==> {
      $value = shape('value' => vec[1, 2]);
      expect(ResolverLookupTestCodegenTargetClass::nestedArguments($value))
        ->toEqual($value);
      expect(ResolverLookupTestCodegenTargetClass::nullableArgument(null))
        ->toEqual(41);
      $helper->badValues(
        ResolverLookupTestCodegenTargetClass::nestedArguments<>,
        dict['wrong element' => shape('value' => vec['1'])],
      );
    })
    ->test('stop_at_unhandled_opaque_boundaries', () ==> {
      expect_invoked(
        () ==> resolver_lookup_body<TResolverOpaqueClass>(
          dict[],
          ($alias, $_)[] ==> {
            expect($alias['alias'])->toEqual(
              (string)TResolverOpaqueClass::class,
            );
            return null;
          },
        ),
      )->toHaveThrown<InvariantException>(
        'This type is a newtype and no $type_alias_asserters entry was provided.',
      );
    });
}
