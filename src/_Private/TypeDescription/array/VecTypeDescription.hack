/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class VecTypeDescription extends BaseTypeDescription {
  use NotASpecialType, PrefersStatement;

  public function __construct(int $counter, private TypeDescription $value)[] {
    parent::__construct($counter);
  }

  <<__Override>>
  public function getStatementFor(string $sub_expression)[]: string {
    $var_out = $this->getTmpVar();
    $var_v = $this->suffixVariable('$v');

    return Str\format(
      '%s = vec[]; foreach ((%s as vec<_>) as %s) { %s%s[] = %s; }',
      $var_out,
      $sub_expression,
      $var_v,
      $this->value->emitAssertionStatement($var_v),
      $var_out,
      $this->value->emitAssertionExpression($var_v),
    );
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for vec<mixed>',
    );
    return 'vec<_>';
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return $this->value->exactlyMixed();
  }
}
