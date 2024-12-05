/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class NonnullTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'nonnull';
  use AssertUsingAs, NotASpecialType, NotAUserSuppliedFunction;
}
