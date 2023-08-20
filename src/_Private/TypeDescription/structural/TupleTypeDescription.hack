/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

final class TupleTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(
    int $counter,
    private vec<TypeDescription> $elements,
  )[] {
    parent::__construct($counter);
    invariant(
      !C\is_empty($elements),
      'Tuples with zero elements are not supported by hhvm',
    );
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    if ($this->isEnforceable()) {
      return
        Str\format('%s as %s', $sub_expression, $this->emitEnforceableType());
    }

    $var_partial = $this->suffixVariable('$partial');
    $enforce_rest = Vec\map_with_key(
      $this->elements,
      ($i, $e) ==> {
        $get_index = Str\format('%s[%d]', $var_partial, $i);
        return $e->isEnforceable()
          ? $get_index
          : $e->emitAssertionExpression($get_index);
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

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for tuples containing only enforceable types',
    );
    return $this->getRHSOfAs();
  }

  <<__Override>>
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
