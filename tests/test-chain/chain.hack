/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\Project_BEjhs0zCRby4\GeneratedTestChain;

use namespace HTL\TestChain;
use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:d4eb78c9680f3f80f43b'])>>

async function tests_async(
  TestChain\ChainController<\HTL\TestChain\Chain> $controller,
)[defaults]: Awaitable<TestChain\ChainController<\HTL\TestChain\Chain>> {
  return $controller
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\deep_alias_test_async<>,
    )
    ->addTestGroupAsync(\HTL\StaticTypeAssertionCodegen\Tests\dict_test_async<>)
    ->addTestGroupAsync(\HTL\StaticTypeAssertionCodegen\Tests\enum_test_async<>)
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\generic_alias_handler_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\keyset_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\newtype_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\resolver_lookup_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\shape_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\statement_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\tuple_test_async<>,
    )
    ->addTestGroupAsync(
      \HTL\StaticTypeAssertionCodegen\Tests\vec_or_dict_test_async<>,
    )
    ->addTestGroupAsync(\HTL\StaticTypeAssertionCodegen\Tests\vec_test_async<>);
}
