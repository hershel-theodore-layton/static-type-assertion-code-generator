/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

// Does not support class constant shape keys (yet?)
final class ShapeField {
  public function __construct(
    private string $name,
    private bool $optional,
    private TypeDescription $type,
  ) {}

  public function getName(): string {
    return $this->name;
  }

  public function getNameQuoteDelimited(): string {
    return \var_export($this->name, true);
  }

  public function getKey(): string {
    $name = $this->getNameQuoteDelimited();
    return $this->optional ? '?'.$name : $name;
  }

  public function isOptional(): bool {
    return $this->optional;
  }

  public function getTypeDescription(): TypeDescription {
    return $this->type;
  }
}
