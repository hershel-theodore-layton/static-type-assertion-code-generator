/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class NullableTypeDescription extends BaseTypeDescription {
  use NotAnExactSpecialType, PrefersStatement;

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
  public function getStatementFor(string $sub_expression)[]: string {
    $out_var = $this->getTmpVar();

    return Str\format(
      'if (%s is null) { %s = null; } else { %s %s = %s;}',
      $sub_expression,
      $out_var,
      $this->inner->emitAssertionStatement($sub_expression),
      $out_var,
      $this->inner->emitAssertionExpression($sub_expression),
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
