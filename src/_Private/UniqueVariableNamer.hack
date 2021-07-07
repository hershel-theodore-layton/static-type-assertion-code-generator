/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

final class VariableNamer {
  private int $i = 0;

  public function name(string $name): string {
    $i = $this->i;
    $this->i++;
    return $name.'__'.$i;
  }
}
