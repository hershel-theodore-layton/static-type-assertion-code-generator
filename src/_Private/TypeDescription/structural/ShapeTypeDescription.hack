/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

final class ShapeTypeDescription extends BaseTypeDescription {
  use NotASpecialType, NotAUserSuppliedFunction, PrefersStatement;

  private string $suffix;

  public function __construct(
    int $counter,
    private vec<ShapeField> $fields,
    private bool $allows_unknown_fields,
    private string $closed_shape_suffix,
  )[] {
    parent::__construct($counter);
    $this->suffix = $allows_unknown_fields ? '...' : $closed_shape_suffix;
  }

  <<__Override>>
  public function getStatementFor(string $sub_expression)[]: string {
    $var_out = $this->getTmpVar();

    $manual_override = vec[];
    foreach (
      Vec\filter(
        $this->fields,
        $f ==> !$f->getTypeDescription()->isEnforceable(),
      ) as $f
    ) {
      $index_op = Str\format('%s[%s]', $var_out, $f->getSourceRepr());

      if ($f->isOptional()) {
        $manual_override[] = Str\format(
          "if (Shapes::keyExists(%s, %s)) { \n%s%s = %s; \n} else { \nShapes::removeKey(inout %s, %s); \n}",
          $var_out,
          $f->getSourceRepr(),
          format_statements(
            $f->getTypeDescription()->emitAssertionStatement($index_op),
          ),
          $index_op,
          $f->getTypeDescription()->emitAssertionExpression($index_op),
          $var_out,
          $f->getSourceRepr(),
        );
      } else {
        $manual_override[] = Str\format(
          '%s%s = %s;',
          format_statements(
            $f->getTypeDescription()->emitAssertionStatement($index_op),
          ),
          $index_op,
          $f->getTypeDescription()->emitAssertionExpression($index_op),
        );
      }
    }

    return Str\format(
      "%s = %s as %s; \n%s\n",
      $var_out,
      $sub_expression,
      $this->getRHSOfAs(),
      Str\join($manual_override, " \n"),
    );
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for shapes containing only enforceable types',
    );
    return $this->getRHSOfAs();
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return
      C\every($this->fields, $f ==> $f->getTypeDescription()->isEnforceable());
  }

  private function getRHSOfAs()[]: string {
    return Vec\map(
      $this->fields,
      $f ==> {
        $key = $f->getKey();
        $type = $f->getTypeDescription();
        return Str\format(
          '%s => %s',
          $key,
          $type->isEnforceable() ? $type->emitEnforceableType() : 'mixed',
        );
      },
    )
      |> Vec\concat($$, vec[$this->suffix])
      |> Str\join($$, ", \n")
      |> Str\format("shape(\n%s)", $$);
  }
}
