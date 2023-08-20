/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class VecTypeDescription implements TypeDescription {
  use NotASpecialType;

  public function __construct(private TypeDescription $value)[] {}

  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  )[write_props]: string {
    if ($this->value->exactlyMixed()) {
      return Str\format('%s as vec<_>', $sub_expression);
    }

    $var_out = $variable_namer->name('$out');
    $var_v = $variable_namer->name('$v');
    return Str\format(
      '() ==> { %s = vec[]; foreach ((%s as vec<_>) as %s) { %s[] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_v,
      $var_out,
      $this->value->emitAssertionExpression($variable_namer, $var_v),
      $var_out,
    );
  }

  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for vec<mixed>',
    );
    return 'vec<_>';
  }

  public function isEnforceable()[]: bool {
    return $this->value->exactlyMixed();
  }
}
