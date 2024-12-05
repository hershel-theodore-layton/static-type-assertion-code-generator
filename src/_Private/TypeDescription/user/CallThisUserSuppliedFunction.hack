/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class CallThisUserSuppliedFunction extends BaseTypeDescription {
  use NotAnExactSpecialType, PrefersExpression;

  public function __construct(
    int $counter,
    private string $func,
    private bool $isSubtypeOfArraykey,
  )[] {
    parent::__construct($counter);
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    return Str\format('%s(%s)', $this->func, $sub_expression);
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant_violation('User supplied handlers are not enforceable');
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return false;
  }

  <<__Override>>
  public function isUserSuppliedFunction()[]: bool {
    return true;
  }

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return $this->isSubtypeOfArraykey;
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return false;
  }
}
