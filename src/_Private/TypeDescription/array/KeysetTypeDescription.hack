/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class KeysetTypeDescription implements TypeDescription {
  use NotASpecialType;

  public function __construct(private TypeDescription $key) {
    invariant(
      $key->subtypeOfArraykey(),
      'Keysets must have an arraykey key type',
    );
  }

  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  ): string {
    if ($this->key->exactlyArraykey()) {
      return Str\format('%s as keyset<_>', $sub_expression);
    }

    $var_out = $variable_namer->name('$out');
    $var_k = $variable_namer->name('$k');
    return Str\format(
      '() ==> { %s = keyset[]; foreach ((%s as keyset<_>) as %s) { %s[] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_k,
      $var_out,
      $this->key->emitAssertionExpression($variable_namer, $var_k),
      $var_out,
    );

  }

  public function emitEnforceableType(): string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for keyset<arraykey>',
    );
    return 'keyset<_>';
  }

  public function isEnforceable(): bool {
    return $this->key->exactlyArraykey();
  }
}
