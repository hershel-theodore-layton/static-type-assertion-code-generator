/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class ArraykeyTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'arraykey';
  use AssertUsingAs;

  public function exactlyArraykey()[]: bool {
    return true;
  }

  public function exactlyMixed()[]: bool {
    return false;
  }

  public function subtypeOfArraykey()[]: bool {
    return true;
  }

  public function superTypeOfNull()[]: bool {
    return false;
  }
}
