/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotAnExactSpecialType {
  require implements TypeDescription;

  <<__Override>>
  public function exactlyArraykey()[]: bool {
    return false;
  }

  <<__Override>>
  public function exactlyInt()[]: bool {
    return false;
  }
  
  <<__Override>>
  public function exactlyMixed()[]: bool {
    return false;
  }
}
