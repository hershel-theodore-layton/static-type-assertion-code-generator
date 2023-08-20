/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class MixedTypeDescription extends BaseTypeDescription {
  public function isEnforceable()[]: bool {
    return true;
  }

  public function emitEnforceableType()[]: string {
    return 'mixed';
  }

  public function emitAssertionExpression(string $sub_expression)[]: string {
    return $sub_expression;
  }

  public function exactlyArraykey()[]: bool {
    return false;
  }

  public function exactlyMixed()[]: bool {
    return true;
  }

  public function subtypeOfArraykey()[]: bool {
    return false;
  }

  public function superTypeOfNull()[]: bool {
    return true;
  }
}
