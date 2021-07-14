/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\{ExpectationFailedException, HackTest};
use namespace HH\Lib\{C, Regex, Str};
use function Facebook\FBExpect\expect;

trait TestHelpers {
  require extends HackTest;

  private static ?dict<string, shape('body' => string, 'type' => string)> $code;

  <<__ReturnDisposable>>
  final protected static function newCodegenHelper(): CodegenHelper {
    invariant(self::$code is null, 'Can not call %s twice', __METHOD__);
    self::$code = dict[];

    return new CodegenHelper(
      C\lastx(Str\split(static::class, '\\')).'CodegenTargetClass',
      $code ==> {
        self::$code = $code;
      },
    );
  }

  final static protected function okayValues<<<__Explicit>> T>(
    (function(mixed): T) $assertion,
    dict<string, T> $values,
  ): void {
    foreach ($values as $name => $value) {
      try {
        $new_value = $assertion($value);
        expect($new_value)->toEqual($value, '%s was not preserved', $name);
      } catch (\TypeAssertionException $e) {
        throw new ExpectationFailedException(Str\format(
          'Expected %s to pass the assertion, but got: %s',
          $name,
          $e->toString(),
        ));
      }
    }
  }

  final static protected function badValues(
    (function(mixed): mixed) $assertion,
    dict<string, mixed> $values,
  ): void {
    foreach ($values as $name => $value) {
      try {
        $assertion($value);
        throw new ExpectationFailedException(Str\format(
          'Expected %s to fail the assertion, but it did not fail',
          $name,
        ));
      } catch (\TypeAssertionException $_) {
      }
    }
  }

  final static protected function bodyOfMethodOughtToBe(
    string $method,
    string $expression,
  ): void {
    $body = Str\replace(
      $expression,
      '__SEED__',
      '$htl_static_type_assertion_codegen_seed_expression',
    );

    invariant(self::$code is nonnull, 'No code has been generated yet');
    $actual_body = Regex\replace_with(
      self::$code[$method]['body'],
      re'/\\$(?<var_name>\w+)__\d+/',
      $match ==> '$'.$match['var_name'],
    );

    expect($actual_body)->toEqual($body);
  }
}
