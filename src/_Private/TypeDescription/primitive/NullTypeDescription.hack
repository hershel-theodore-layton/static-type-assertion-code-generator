/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class NullTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'null';
  use AssertUsingAs, NotAnExactSpecialType, NotAUserSuppliedFunction;

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return false;
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return true;
  }
}
