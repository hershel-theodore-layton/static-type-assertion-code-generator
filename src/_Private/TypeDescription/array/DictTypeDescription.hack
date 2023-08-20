/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class DictTypeDescription extends BaseTypeDescription {
  use NotASpecialType, PrefersStatement;

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
  public function getStatementFor(string $sub_expression)[]: string {
    $var_out = $this->getTmpVar();
    $var_k = $this->suffixVariable('$k');
    $var_v = $this->suffixVariable('$v');

    // No need for a statement first, since we've got something arraykey-ish.
    $key_expression = $this->key->exactlyArraykey()
      ? $var_k
      : $this->key->emitAssertionExpression($var_k);

    $value_statement = $this->value->emitAssertionStatement($var_v);

    return Str\format(
      '%s = dict[]; foreach ((%s as dict<_, _>) as %s => %s) { %s%s[%s] = %s; }',
      $var_out,
      $sub_expression,
      $var_k,
      $var_v,
      format_statements($value_statement),
      $var_out,
      $key_expression,
      $this->value->emitAssertionExpression($var_v),
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
