/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class KeysetTypeDescription extends BaseTypeDescription {
  use NotASpecialType, NotAUserSuppliedFunction, PrefersStatement;

  public function __construct(int $counter, private TypeDescription $key)[] {
    parent::__construct($counter);
    invariant(
      $key->subtypeOfArraykey(),
      'Keysets must have an arraykey key type',
    );
  }

  <<__Override>>
  public function getStatementFor(string $sub_expression)[]: string {
    $var_out = $this->getTmpVar();
    $var_k = $this->suffixVariable('$k');

    return Str\format(
      "%s = keyset[]; \nforeach ((%s as keyset<_>) as %s) { \n%s[] = %s; \n}\n",
      $var_out,
      $sub_expression,
      $var_k,
      $var_out,
      $this->key->emitAssertionExpression($var_k),
    );

  }

  <<__Override>>
  public function emitEnforceableType()[]: string {
    invariant(
      $this->isEnforceable(),
      'This operation is only supported for keyset<arraykey>',
    );
    return 'keyset<_>';
  }

  <<__Override>>
  public function isEnforceable()[]: bool {
    return $this->key->exactlyArraykey();
  }
}
