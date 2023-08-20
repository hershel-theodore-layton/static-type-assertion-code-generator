/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

// Does not support class constant shape keys (yet?)
final class ShapeField {
  public function __construct(
    private arraykey $nameValue,
    private string $sourceRepr,
    private bool $optional,
    private TypeDescription $type,
  )[] {}

  /**
   * Used to detect unsound class constant use.
   * ```
   * class OhNo {
   *   const string A = 'a';
   *   const string B = 'a';
   *   //               ^^^
   * }
   * type DuplicateKey = shape(OhNo::A => int, OhNo::B => string);
   * ```
   */
  public function getNameValue()[]: arraykey {
    return $this->nameValue;
  }

  public function getSourceRepr()[]: string {
    return $this->sourceRepr;
  }

  public function getKey()[]: string {
    $name = $this->getSourceRepr();
    return $this->optional ? '?'.$name : $name;
  }

  public function isOptional()[]: bool {
    return $this->optional;
  }

  public function getTypeDescription()[]: TypeDescription {
    return $this->type;
  }
}
