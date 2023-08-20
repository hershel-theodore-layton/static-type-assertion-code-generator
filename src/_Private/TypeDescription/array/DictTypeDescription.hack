/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class DictTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(
    int $counter,
    private TypeDescription $key,
    private TypeDescription $value,
  )[] {
    parent::__construct($counter);
    invariant(
      $key->subtypeOfArraykey(),
      'Dicts must have an arraykey key type',
    );
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    if ($this->key->exactlyArraykey() && $this->value->exactlyMixed()) {
      return Str\format('%s as dict<_, _>', $sub_expression);
    }

    $var_out = $this->suffixVariable('$out');
    $var_k = $this->suffixVariable('$k');
    $var_v = $this->suffixVariable('$v');
    return Str\format(
      '() ==> { %s = dict[]; foreach ((%s as dict<_, _>) as %s => %s) { %s[%s] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_k,
      $var_v,
      $var_out,
      $this->key->exactlyArraykey()
        ? $var_k
        : $this->key->emitAssertionExpression($var_k),
      $this->value->exactlyMixed()
        ? $var_v
        : $this->value->emitAssertionExpression($var_v),
      $var_out,
    );
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for dict<arraykey, mixed>',
    );
    return 'dict<_, _>';
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return $this->key->exactlyArraykey() && $this->value->exactlyMixed();
  }
}
