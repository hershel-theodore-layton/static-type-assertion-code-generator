/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class CallThisUserSuppliedFunction extends BaseTypeDescription {
  use NotAnExactSpecialType;

  public function __construct(
    int $counter,
    private string $func,
    private bool $isSubtypeOfArraykey,
  )[] {
    parent::__construct($counter);
  }

  public function emitAssertionExpression(string $sub_expression)[]: string {
    return Str\format('%s(%s)', $this->func, $sub_expression);
  }

  public function emitEnforceableType()[]: string {
    invariant_violation('User supplied handlers are not enforceable');
  }

  public function isEnforceable()[]: bool {
    return false;
  }

  public function subtypeOfArraykey()[]: bool {
    return $this->isSubtypeOfArraykey;
  }

  public function superTypeOfNull()[]: bool {
    return false;
  }
}
