/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

abstract class BaseTypeDescription implements TypeDescription {
  public function __construct(private int $counter)[] {}

  final protected function getTmpVar()[]: string {
    return $this->suffixVariable('$out');
  }

  final public function suffixVariable(string $name)[]: string {
    return $name.'__'.$this->counter;
  }
}
