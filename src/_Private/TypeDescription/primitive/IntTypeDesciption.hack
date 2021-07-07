/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class IntTypeDescription
  implements MustHaveTypenameConstant, TypeDescription {
  const string TYPE_NAME = 'int';
  use AssertUsingAs, NotAnExactSpecialType;

  public function subtypeOfArraykey(): bool {
    return true;
  }

  public function superTypeOfNull(): bool {
    return false;
  }
}
