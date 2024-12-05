/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class ArraykeyTypeDescription extends BaseTypeDescription {
  const string TYPE_NAME = 'arraykey';
  use AssertUsingAs, NotAUserSuppliedFunction;

  <<__Override>>
  public function exactlyArraykey()[]: bool {
    return true;
  }

  <<__Override>>
  public function exactlyInt()[]: bool {
    return false;
  }

  <<__Override>>
  public function exactlyMixed()[]: bool {
    return false;
  }

  <<__Override>>
  public function subtypeOfArraykey()[]: bool {
    return true;
  }

  <<__Override>>
  public function superTypeOfNull()[]: bool {
    return false;
  }
}
