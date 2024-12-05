/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait NotAUserSuppliedFunction {
  require implements TypeDescription;

  <<__Override>>
  public function isUserSuppliedFunction()[]: bool {
    return false;
  }
}
