/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class BoolTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'bool';
  use AssertUsingAs, NotASpecialType, NotAUserSuppliedFunction;
}
