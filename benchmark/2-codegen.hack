/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace HTL\StaticTypeAssertionCodegen;
use namespace HH\Lib\Str;

<<__EntryPoint>>
async function codegen_async(): Awaitable<void> {
  require_once __DIR__.'/../vendor/autoload.hack';
  \Facebook\AutoloadMap\initialize();

  $code = Str\format(<<<'HACK'
/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during benchmarking, run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

function assert_json_shape(mixed $htl_static_type_assertion_codegen_seed_expression): JsonShape {
  return %s;
}

HACK
  ,
  StaticTypeAssertionCodegen\emit_body_for_assertion_function(
    StaticTypeAssertionCodegen\from_type<JsonShape>(),
  ),
  );
  \file_put_contents(__DIR__.'/assert_json_shape.hack', $code);
}
