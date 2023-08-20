/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

final class ShapeTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(
    int $counter,
    private vec<ShapeField> $fields,
    private bool $allowsUnknownFields,
  )[] {
    parent::__construct($counter);
    $unique_fields = Vec\unique_by($fields, $f ==> $f->getName());
    invariant(
      C\count($unique_fields) === C\count($fields),
      'Shape definition contains duplicate fields',
    );
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    if ($this->isEnforceable()) {
      return
        Str\format('%s as %s', $sub_expression, $this->emitEnforceableType());
    }

    $var_partial = $this->suffixVariable('$partial');

    $manual_override = vec[];
    foreach (
      Vec\filter(
        $this->fields,
        $f ==> !$f->getTypeDescription()->isEnforceable(),
      ) as $f
    ) {
      $index_op = Str\format('%s[%s]', $var_partial, $f->getSourceRepr());

      if ($f->isOptional()) {
        $manual_override[] = Str\format(
          'if (Shapes::keyExists(%s, %s)) { %s = %s; } else { Shapes::removeKey(inout %s, %s); }',
          $var_partial,
          $f->getSourceRepr(),
          $index_op,
          $f->getTypeDescription()->emitAssertionExpression($index_op),
          $var_partial,
          $f->getSourceRepr(),
        );
      } else {
        $manual_override[] = Str\format(
          '%s = %s;',
          $index_op,
          $f->getTypeDescription()->emitAssertionExpression($index_op),
        );
      }
    }

    return Str\format(
      '() ==> { %s = %s as %s; %s return %s; }()',
      $var_partial,
      $sub_expression,
      $this->getRHSOfAs(),
      Str\join($manual_override, ' '),
      $var_partial,
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
      |> Str\join($$, ', ')
      |> $this->allowsUnknownFields
        ? (C\is_empty($this->fields) ? $$.'...' : $$.', ...')
        : $$
      |> Str\format('shape(%s)', $$);
  }
}
