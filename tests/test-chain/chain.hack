/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\Project_BEjhs0zCRby4\GeneratedTestChain;

use namespace HTL\TestChain;

async function tests_async(
)[defaults]: Awaitable<TestChain\ChainController<TestChain\Chain>> {
  return TestChain\ChainController::create(TestChain\TestChain::create<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\dict_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\enum_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\keyset_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\newtype_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\shape_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\statement_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\tuple_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\vec_or_dict_test<>)
    ->addTestGroup(\HTL\StaticTypeAssertionCodegen\Tests\vec_test<>);
}
