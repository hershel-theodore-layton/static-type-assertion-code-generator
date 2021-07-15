/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace HH\Lib\Str;
<<__EntryPoint>>
async function run_static_type_assertion_code_generator_async(
): Awaitable<void> {
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

  $start = \clock_gettime_ns(\CLOCK_MONOTONIC);
  assert_json_shape($json);
  $total = \clock_gettime_ns(\CLOCK_MONOTONIC) - $start;

  echo Str\format(<<<'STATS'
StaticTypeAssertionCodegen stats:
Total time:            %d ns (%f ms)

STATS
  ,
  $total,
  $total / 1000000.,
  );
}
