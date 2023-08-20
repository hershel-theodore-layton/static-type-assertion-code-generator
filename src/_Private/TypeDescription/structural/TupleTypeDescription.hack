/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

final class TupleTypeDescription implements TypeDescription {
  use NotASpecialType;

  public function __construct(private vec<TypeDescription> $elements)[] {
    invariant(
      !C\is_empty($elements),
      'Tuples with zero elements are not supported by hhvm',
    );
  }

  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  )[write_props]: string {
    if ($this->isEnforceable()) {
      return
        Str\format('%s as %s', $sub_expression, $this->emitEnforceableType());
    }

    $var_partial = $variable_namer->name('$partial');
    $enforce_rest = Vec\map_with_key(
      $this->elements,
      ($i, $e) ==> {
        $get_index = Str\format('%s[%d]', $var_partial, $i);
        return $e->isEnforceable()
          ? $get_index
          : $e->emitAssertionExpression($variable_namer, $get_index);
      },
    )
      |> Str\join($$, ', ')
      |> Str\format('tuple(%s)', $$);

    return Str\format(
      '() ==> { %s = %s as %s; return %s; }()',
      $var_partial,
      $sub_expression,
      $this->getRHSOfAs(),
      $enforce_rest,
    );
  }

  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for tuples containing only enforceable types',
    );
    return $this->getRHSOfAs();
  }

  public function isEnforceable()[]: bool {
    return C\every($this->elements, $e ==> $e->isEnforceable());
  }

  private function getRHSOfAs()[]: string {
    return Vec\map(
      $this->elements,
      $e ==> $e->isEnforceable() ? $e->emitEnforceableType() : 'mixed',
    )
      |> Str\join($$, ', ')
      |> Str\format('(%s)', $$);
  }
}
