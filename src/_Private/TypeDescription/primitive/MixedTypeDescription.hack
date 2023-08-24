/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class MixedTypeDescription extends BaseTypeDescription {
  use PrefersExpression;

  <<__Override>>
  public function isEnforceable()[]: bool {
    return true;
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    return 'mixed';
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    return $sub_expression;
  }

  <<__Override>>
  public function exactlyArraykey()[]: bool {
    return false;
  }

  <<__Override>>
  public function exactlyInt()[]: bool {
    return false;
  }

  <<__Override>>
  public function exactlyMixed()[]: bool {
    return true;
  }

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return false;
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return true;
  }
}
