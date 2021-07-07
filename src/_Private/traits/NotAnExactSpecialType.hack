/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotAnExactSpecialType {
  public function exactlyArraykey(): bool {
    return false;
  }
  public function exactlyMixed(): bool {
    return false;
  }
}
