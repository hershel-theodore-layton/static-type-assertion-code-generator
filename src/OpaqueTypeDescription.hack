/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen {
  /**
   * This library reserves the right to change anything
   * about the representation of a type description.
   * This type behaves like a black box to consumers of this library.
   */
  newtype OpaqueTypeDescription = _Private\TypeDescription;

  namespace _Private {
    use type HTL\StaticTypeAssertionCodegen\OpaqueTypeDescription;

    /**
     * Calling this function outside of this library is not supported.
     * It is `_Private` for a reason! Bad, no, do not touch!
     */
    function remove_opaqueness(OpaqueTypeDescription $opaque): TypeDescription {
      return $opaque;
    }

    /**
     * Any TypeDescription leaving a non `_Private` function must first be made opaque.
     * Failure to do so is considered a bug.
     */
    function make_opaque(TypeDescription $bare): OpaqueTypeDescription {
      return $bare;
    }
  }
}
