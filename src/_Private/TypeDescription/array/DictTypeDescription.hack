/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class DictTypeDescription implements TypeDescription {
  use NotASpecialType;

  public function __construct(
    private TypeDescription $key,
    private TypeDescription $value,
  )[] {
    invariant(
      $key->subtypeOfArraykey(),
      'Dicts must have an arraykey key type',
    );
  }

  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  )[write_props]: string {
    if ($this->key->exactlyArraykey() && $this->value->exactlyMixed()) {
      return Str\format('%s as dict<_, _>', $sub_expression);
    }

    $var_out = $variable_namer->name('$out');
    $var_k = $variable_namer->name('$k');
    $var_v = $variable_namer->name('$v');
    return Str\format(
      '() ==> { %s = dict[]; foreach ((%s as dict<_, _>) as %s => %s) { %s[%s] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_k,
      $var_v,
      $var_out,
      $this->key->exactlyArraykey()
        ? $var_k
        : $this->key->emitAssertionExpression($variable_namer, $var_k),
      $this->value->exactlyMixed()
        ? $var_v
        : $this->value->emitAssertionExpression($variable_namer, $var_v),
      $var_out,
    );
  }

  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for dict<arraykey, mixed>',
    );
    return 'dict<_, _>';
  }

  public function isEnforceable()[]: bool {
    return $this->key->exactlyArraykey() && $this->value->exactlyMixed();
  }
}
