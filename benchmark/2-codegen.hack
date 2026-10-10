/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace HH;
use namespace HH\Lib\Str;
use namespace HTL\StaticTypeAssertionCodegen;
use type HTL\Pragma\Pragmas;
use type Exception;
use function HTL\PhaLintersServer\hackfmt_and_sign_hack_source_do_not_use_async;
use function file_put_contents;

<<file: Pragmas(vec['PhaLinters', 'fixme:autoload_your_code'])>>

<<__EntryPoint>>
async function codegen_async()[defaults]: Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    // Abuse the poor typing of array_reduce to invoke a dynamic callable without hh_client noticing
    \array_reduce(vec[null], HH\dynamic_fun('Facebook\AutoloadMap\initialize'));
  }

  $panic = ($message)[]: nothing ==> {
    throw new Exception($message);
  };

  $code = Str\format(
    <<<'HACK'
/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during benchmarking. Run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:'])>>

final abstract class AssertJsonShape {
  public static function assertJsonShape(mixed $htl_untyped_variable)[]: JsonShape {
    %s
  }
  private static function assertTEntities(mixed $htl_untyped_variable)[]: TEntities {
    %s
  }
  private static function assertTUser(mixed $htl_untyped_variable)[]: TUser {
    %s
  }
}

HACK
    ,
    StaticTypeAssertionCodegen\emit_body_for_assertion_function(
      StaticTypeAssertionCodegen\from_type<JsonShape>(
        dict[
          (string)TEntities::class => 'self::assertTEntities',
          (string)TUser::class => 'self::assertTUser',
        ],
        $panic,
      ),
    ),
    StaticTypeAssertionCodegen\emit_body_for_assertion_function(
      StaticTypeAssertionCodegen\from_type<TEntities>(dict[], $panic),
    ),
    StaticTypeAssertionCodegen\emit_body_for_assertion_function(
      StaticTypeAssertionCodegen\from_type<TUser>(dict[], $panic),
    ),
  );
  $path = __DIR__.'/AssertJsonShape.hack';
  $signed = await hackfmt_and_sign_hack_source_do_not_use_async($code);
  file_put_contents($path, $signed);
}
