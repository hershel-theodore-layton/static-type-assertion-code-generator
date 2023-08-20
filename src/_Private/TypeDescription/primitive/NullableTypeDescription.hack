/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class NullableTypeDescription extends BaseTypeDescription {
  use NotAnExactSpecialType;

  public function __construct(int $counter, private TypeDescription $inner)[] {
    parent::__construct($counter);
    invariant(
      !$inner->superTypeOfNull(),
      'Can not create a nullable nullable type.',
    );
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return $this->inner->isEnforceable();
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    return $this->isEnforceable()
      ? '?'.$this->inner->emitEnforceableType()
      : 'mixed';
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    $var_temp = $this->suffixVariable('$temp');
    return $this->isEnforceable()
      ? Str\format('%s as %s', $sub_expression, $this->emitEnforceableType())
      : Str\format(
          '() ==> { %s = %s; return %s is null ? null : %s; }()',
          $var_temp,
          $sub_expression,
          $var_temp,
          $this->inner->emitAssertionExpression($var_temp),
        );
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return true;
  }

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return false;
  }
}
