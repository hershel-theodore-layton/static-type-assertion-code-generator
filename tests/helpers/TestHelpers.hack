/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\Str;
use namespace HTL\Expect;
use function HTL\Expect\expect;

final class TestHelpers {
  private ?dict<string, shape('body' => string, 'type' => string /*_*/)> $code;

  <<__ReturnDisposable>>
  public function newCodegenHelper(string $prefix)[write_props]: CodegenHelper {
    invariant($this->code is null, 'Can not call %s twice', __METHOD__);
    $this->code = dict[];

    return new CodegenHelper(
      $prefix.'CodegenTargetClass',
      $code ==> {
        $this->code = $code;
      },
    );
  }

  public function okayValues<<<__Explicit>> T>(
    (function(mixed)[]: T) $assertion,
    dict<string, T> $values,
  )[defaults]: void {
    foreach ($values as $name => $value) {
      try {
        $new_value = $assertion($value);
        expect($new_value)->toEqual($value);
      } catch (\TypeAssertionException $e) {
        throw new Expect\Surprise(Str\format(
          'Expected %s to pass the assertion, but got: %s',
          $name,
          $e->toString(),
        ));
      }
    }
  }

  public function badValues(
    (function(mixed)[]: mixed) $assertion,
    dict<string, mixed> $values,
  )[]: void {
    foreach ($values as $name => $value) {
      try {
        $assertion($value);
        throw new Expect\Surprise(Str\format(
          'Expected %s to fail the assertion, but it did not fail',
          $name,
        ));
      } catch (\TypeAssertionException $_) {
      }
    }
  }

  public function bodyOfMethodOughtToBe(
    string $method,
    string $expression,
  )[]: void {
    $body = Str\replace($expression, '__SEED__', '$htl_untyped_variable');
    invariant($this->code is nonnull, 'No code has been generated yet');
    $generated_without_newlines =
      Str\replace($this->code[$method]['body'], "\n", '');
    expect($generated_without_newlines)->toEqual($body);
  }
}
