/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotAnExactSpecialType {
  require implements TypeDescription;
  public function exactlyArraykey()[]: bool {
    return false;
  }
  public function exactlyInt()[]: bool {
    return false;
  }
  public function exactlyMixed()[]: bool {
    return false;
  }
}
