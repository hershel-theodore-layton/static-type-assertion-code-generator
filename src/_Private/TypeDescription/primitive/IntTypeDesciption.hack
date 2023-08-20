/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class IntTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'int';
  use AssertUsingAs, NotAnExactSpecialType;

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return true;
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return false;
  }
}
