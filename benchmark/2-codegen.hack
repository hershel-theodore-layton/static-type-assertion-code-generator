/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace HH;
use namespace HH\Lib\Str;
use namespace HTL\StaticTypeAssertionCodegen;
use function HTL\StaticTypeAssertionCodegen\_Private\hackfmt;

<<__EntryPoint>>
async function codegen_async(): Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    HH\dynamic_fun('Facebook\AutoloadMap\initialize')();
  }

  $panic = ($message)[]: nothing ==> {
    throw new \Exception($message);
  };

  $code = Str\format(<<<'HACK'
/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during benchmarking, run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

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
        TEntities::class => 'self::assertTEntities',
        TUser::class => 'self::assertTUser',
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
  hackfmt(__DIR__.'/AssertJsonShape.hack', $code);
}
