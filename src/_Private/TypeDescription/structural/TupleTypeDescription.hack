/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

final class TupleTypeDescription extends BaseTypeDescription {
  use NotASpecialType, NotAUserSuppliedFunction, PrefersStatement;

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
  public function getStatementFor(string $sub_expression)[]: string {
    $var_out = $this->getTmpVar();

    $statements = Vec\map_with_key(
      $this->elements,
      ($i, $e) ==>
        $e->emitAssertionStatement(Str\format('%s[%d]', $var_out, $i)),
    )
      |> format_statements(...$$);

    $enforce_rest = Vec\map_with_key(
      $this->elements,
      ($i, $e) ==> {
        $get_index = Str\format('%s[%d]', $var_out, $i);
        return $e->isEnforceable()
          ? $get_index
          : $e->emitAssertionExpression($get_index);
      },
    )
      |> Str\join($$, ', ')
      |> Str\format('tuple(%s)', $$);

    return Str\format(
      '%s = %s as %s; %s%s = %s;',
      $var_out,
      $sub_expression,
      $this->getRHSOfAs(),
      $statements,
      $var_out,
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
