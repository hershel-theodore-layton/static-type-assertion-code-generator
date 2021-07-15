/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace Facebook\TypeSpec;
use namespace HH\Lib\Str;

<<__EntryPoint>>
async function run_type_assert_async(): Awaitable<void> {
  require_once __DIR__.'/../vendor/autoload.hack';
  \Facebook\AutoloadMap\initialize();

  if (!\is_readable(__DIR__.'/benchmark.json')) {
    echo "Could not read benchmark.json. Run 1-download.hack first.\n";
    return;
  }

  $error = null;
  $json = \file_get_contents(__DIR__.'/benchmark.json')
    |> \json_decode_with_error(
      $$,
      inout $error,
      true,
      512,
      \JSON_FB_HACK_ARRAYS,
    );

  $step1 = \clock_gettime_ns(\CLOCK_MONOTONIC);
  $typespec = TypeSpec\of<JsonShape>();
  $step2 = \clock_gettime_ns(\CLOCK_MONOTONIC);
  $typespec->assertType($json);
  $step3 = \clock_gettime_ns(\CLOCK_MONOTONIC);

  $making_spec = $step2 - $step1;
  $asserting_type = $step3 - $step2;
  $total = $step3 - $step1;

  echo Str\format(<<<'STATS'
TypeAssert stats:
Creating the TypeSpec: %d ns (%f ms)
Asserting the type:    %d ns (%f ms)
Total time:            %d ns (%f ms)

STATS
  ,
  $making_spec,
  $making_spec / 1000000.,
  $asserting_type,
  $asserting_type / 1000000.,
  $total,
  $total / 1000000.,
  );
}
