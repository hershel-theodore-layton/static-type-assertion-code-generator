/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class NumTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'num';
  use AssertUsingAs, NotASpecialType, NotAUserSuppliedFunction;
}
