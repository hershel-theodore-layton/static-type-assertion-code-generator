/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class VecTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(int $counter, private TypeDescription $value)[] {
    parent::__construct($counter);
  }

  public function emitAssertionExpression(string $sub_expression)[]: string {
    if ($this->value->exactlyMixed()) {
      return Str\format('%s as vec<_>', $sub_expression);
    }

    $var_out = $this->suffixVariable('$out');
    $var_v = $this->suffixVariable('$v');
    return Str\format(
      '() ==> { %s = vec[]; foreach ((%s as vec<_>) as %s) { %s[] = %s; } return %s; }()',
      $var_out,
      $sub_expression,
      $var_v,
      $var_out,
      $this->value->emitAssertionExpression($var_v),
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
