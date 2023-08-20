/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class StringTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'string';
  use AssertUsingAs, NotAnExactSpecialType;

  public function subtypeOfArraykey()[]: bool {
    return true;
  }

  public function superTypeOfNull()[]: bool {
    return false;
  }
}
