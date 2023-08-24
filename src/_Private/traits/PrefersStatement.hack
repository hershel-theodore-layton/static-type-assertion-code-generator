/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

trait PrefersStatement {
  require implements TypeDescription;

  protected abstract function getStatementFor(string $sub_expression)[]: string;

  final protected function getTmpVar()[]: string {
    return $this->suffixVariable('$out');
  }

  final public function emitAssertionExpression(
    string $sub_expression,
  )[]: string {
    return $this->isEnforceable()
      ? Str\format('%s as %s', $sub_expression, $this->emitEnforceableType())
      : $this->getTmpVar();
  }

  final public function emitAssertionStatement(
    string $sub_expression,
  )[]: string {
    return
      $this->isEnforceable() ? '' : $this->getStatementFor($sub_expression);
  }
}
