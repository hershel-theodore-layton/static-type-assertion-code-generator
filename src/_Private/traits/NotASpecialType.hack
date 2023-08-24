/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotASpecialType {
  require implements TypeDescription;
  use NotAnExactSpecialType;

  public function subtypeOfArraykey()[]: bool {
    return false;
  }

  public function superTypeOfNull()[]: bool {
    return false;
  }
}
