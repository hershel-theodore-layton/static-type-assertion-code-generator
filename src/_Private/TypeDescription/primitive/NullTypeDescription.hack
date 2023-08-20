/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class NullTypeDescription implements TypeDescription {
  const string TYPE_NAME = 'null';
  use AssertUsingAs, NotAnExactSpecialType;

  public function subtypeOfArraykey()[]: bool {
    return false;
  }

  public function superTypeOfNull()[]: bool {
    return true;
  }
}
