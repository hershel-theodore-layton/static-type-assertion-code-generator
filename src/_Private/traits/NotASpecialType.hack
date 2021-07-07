/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotASpecialType {
  use NotAnExactSpecialType;

  public function subtypeOfArraykey(): bool {
    return false;
  }

  public function superTypeOfNull(): bool {
    return false;
  }
}
