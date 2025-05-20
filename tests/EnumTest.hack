/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str};
use namespace HTL\{StaticTypeAssertionCodegen, TestChain};
use function HTL\Expect\expect_invoked;

enum SomeEnum: int {
  ONE = 1;
}

<<TestChain\Discover>>
function enum_test(TestChain\Chain $chain)[defaults]: TestChain\Chain {
  $helper = new TestHelpers();
  using $ch = $helper->newCodegenHelper('EnumTest');
  $ch->createMethod<SomeEnum>(
    'someEnum',
    dict[SomeEnum::class => 'assert_enum'],
  );
  $ch->createMethod<?SomeEnum>(
    'nullableEnum',
    dict[SomeEnum::class => 'assert_enum'],
  );
  $ch->createMethod<keyset<SomeEnum>>(
    'keysetOfSomeEnum',
    dict[SomeEnum::class => 'assert_enum'],
  );

  return $chain->group(__FUNCTION__)
    ->test('test_throws_when_no_enum_handler_was_provided', () ==> {
      expect_invoked(
        () ==> StaticTypeAssertionCodegen\from_type<SomeEnum>(dict[], panic<>),
      )
        ->toHaveThrown<InvariantException>(
          'Support for enums must be added using a $type_alias_asserters entry',
        );
    })
    ->test('test_uses_user_provided_asserters', () ==> {
      $helper->okayValues<SomeEnum>(
        EnumTestCodegenTargetClass::someEnum<>,
        dict['member of SomeEnum' => SomeEnum::ONE],
      );
    })
    ->test('test_nullable_enums', () ==> {
      $helper->okayValues<?SomeEnum>(
        EnumTestCodegenTargetClass::nullableEnum<>,
        dict['member of SomeEnum' => SomeEnum::ONE, 'null' => null],
      );
    })
    ->test('test_can_be_used_as_an_arraykey', () ==> {
      $helper->okayValues<keyset<SomeEnum>>(
        EnumTestCodegenTargetClass::keysetOfSomeEnum<>,
        dict[
          'empty keyset' => keyset[],
          'keyset of SomeEnum' => keyset[SomeEnum::ONE],
        ],
      );
    });
}

function assert_enum(mixed $m)[]: SomeEnum {
  if ($m is arraykey && C\contains_key(SomeEnum::getNames(), $m)) {
    return $m as SomeEnum;
  } else {
    throw new \TypeAssertionException(Str\format(
      'Expected %s, got %s',
      SomeEnum::class,
      \is_object($m) ? \get_class($m) : \gettype($m),
    ));
  }
}
