/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class VecOrDictTypeDescription extends BaseTypeDescription {
  use NotASpecialType;

  public function __construct(
    int $counter,
    private TypeDescription $key,
    private TypeDescription $value,
  )[] {
    parent::__construct($counter);
    // Preventing accidental use of an enum / string / or opaque type.
    // The vec keys will get reordered 0..n-1.
    // All the invariants of your key type will get erased.
    // Arraykey and int are fine, since 0..INT64_MAX are arraykey and int.
    invariant(
      $key->exactlyArraykey() || $key->exactlyInt(),
      'Key type must EXACTLY arraykey or int, because vec keys are 0..n-1.',
    );
  }

  <<__Override>>
  public function emitAssertionExpression(string $sub_expression)[]: string {
    return $this->isTopType()
      ? Str\format(
          '(%s |> $$ is vec<_> ? $$ : $$ as dict<_, _>)',
          $sub_expression,
        )
      : $this->getTmpVar();
  }

  <<__Override>>
  public function emitAssertionStatement(string $sub_expression)[]: string {
    if ($this->isTopType()) {
      return '';
    }

    $var_out = $this->getTmpVar();
    $var_k = $this->suffixVariable('$k');
    $var_v = $this->suffixVariable('$v');

    // No need for a statement first, since we've got something arraykey-ish.
    $key_expression = $this->key->exactlyArraykey()
      ? $var_k
      : $this->key->emitAssertionExpression($var_k);

    $value_statement = $this->value->emitAssertionStatement($var_v);

    return Str\format(
      '%s = dict[]; '.
      'foreach ((%s as KeyedContainer<_, _>) as %s => %s) { %s%s[%s] = %s; } '.
      // This fixup ensures that the vec'ness of the input matches the output.
      // It also throws an exception if the input was not a vec or a dict.
      '%s = %s is vec<_> ? vec(%s) : (%s as dict<_, _> |> %s);',
      $var_out,
      $sub_expression,
      $var_k,
      $var_v,
      format_statements($value_statement),
      $var_out,
      $key_expression,
      $this->value->emitAssertionExpression($var_v),
      $var_out,
      $sub_expression,
      $var_out,
      $sub_expression,
      $var_out,
    );
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant_violation(
      '$x as vec_or_dict<_, _> introduces a bugged type (literal underscore)',
    );
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return false;
  }

  private function isTopType()[]: bool {
    return $this->key->exactlyArraykey() && $this->value->exactlyMixed();
  }
}
