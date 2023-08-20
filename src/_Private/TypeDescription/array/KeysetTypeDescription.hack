/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class KeysetTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(int $counter, private TypeDescription $key)[] {
    parent::__construct($counter);
    invariant(
      $key->subtypeOfArraykey(),
      'Keysets must have an arraykey key type',
    );
  }

  public function emitAssertionExpression(string $sub_expression)[]: string {
    if ($this->key->exactlyArraykey()) {
      return Str\format('%s as keyset<_>', $sub_expression);
    }

    $var_out = $this->suffixVariable('$out');
    $var_k = $this->suffixVariable('$k');
    return Str\format(
      '() ==> { %s = keyset[]; foreach ((%s as keyset<_>) as %s) { %s[] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_k,
      $var_out,
      $this->key->emitAssertionExpression($var_k),
      $var_out,
    );

  }

  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for keyset<arraykey>',
    );
    return 'keyset<_>';
  }

  public function isEnforceable()[]: bool {
    return $this->key->exactlyArraykey();
  }
}
