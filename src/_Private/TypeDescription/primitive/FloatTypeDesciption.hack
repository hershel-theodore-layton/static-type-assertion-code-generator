/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class FloatTypeDescription
  implements MustHaveTypenameConstant, TypeDescription {
  const string TYPE_NAME = 'float';
  use AssertUsingAs, NotASpecialType;
}
