/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class NullableTypeDescription implements TypeDescription {
  use NotAnExactSpecialType;

  public function __construct(private TypeDescription $inner)[] {
    invariant(
      !$inner->superTypeOfNull(),
      'Can not create a nullable nullable type.',
    );
  }

  public function isEnforceable()[]: bool {
    return $this->inner->isEnforceable();
  }

  public function emitEnforceableType()[]: string {
    return $this->isEnforceable()
      ? '?'.$this->inner->emitEnforceableType()
      : 'mixed';
  }

  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  )[write_props]: string {
    $var_temp = $variable_namer->name('$temp');
    return $this->isEnforceable()
      ? Str\format('%s as %s', $sub_expression, $this->emitEnforceableType())
      : Str\format(
          '() ==> { %s = %s; return %s is null ? null : %s; }()',
          $var_temp,
          $sub_expression,
          $var_temp,
          $this->inner->emitAssertionExpression($variable_namer, $var_temp),
        );
  }

  public function superTypeOfNull()[]: bool {
    return true;
  }

  public function subtypeOfArraykey()[]: bool {
    return false;
  }
}
