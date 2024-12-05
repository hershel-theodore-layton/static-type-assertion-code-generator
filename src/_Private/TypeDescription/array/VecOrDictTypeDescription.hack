/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class VecOrDictTypeDescription extends BaseTypeDescription {
  use NotASpecialType, NotAUserSuppliedFunction, PrefersStatement;

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
  public function getStatementFor(string $sub_expression)[]: string {
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
      'foreach ((%s as vec_or_dict<_>) as %s => %s) { %s%s[%s] = %s; } '.
      // This fixup ensures that the vec'ness of the input matches the output.
      '%s = %s is vec<_> ? vec(%s) : %s;',
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
      $var_out,
    );
  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for vec_or_dict<arraykey, mixed>',
    );
    // `as vec_or_dict<_, _>` is bugged, it introduces a literal `_` type.
    // Leaving out a generic is the same as `as vec_or_dict<arraykey, _>`.
    return 'vec_or_dict<_>';
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return $this->key->exactlyArraykey() && $this->value->exactlyMixed();
  }
}
