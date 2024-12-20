/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type Facebook\HackTest\{ExpectationFailedException, HackTest};
use namespace HH\Lib\{C, Str};
use function Facebook\FBExpect\expect;

trait TestHelpers {
  require extends HackTest;

  private static ?dict<string, shape('body' => string, 'type' => string /*_*/)>
    $code;

  <<__ReturnDisposable>>
  final protected static function newCodegenHelper()[defaults]: CodegenHelper {
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
    (function(mixed)[defaults]: T) $assertion,
    dict<string, T> $values,
  )[defaults]: void {
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
    (function(mixed)[_]: mixed) $assertion,
    dict<string, mixed> $values,
  )[ctx $assertion]: void {
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
  )[defaults]: void {
    $body = Str\replace($expression, '__SEED__', '$htl_untyped_variable');
    invariant(self::$code is nonnull, 'No code has been generated yet');
    $generated_without_newlines =
      Str\replace(self::$code[$method]['body'], "\n", '');
    expect($generated_without_newlines)->toEqual($body);
  }
}
