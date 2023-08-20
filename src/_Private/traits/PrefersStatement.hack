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
    return $this->prefersStatement()
      ? $this->getTmpVar()
      : Str\format('%s as %s', $sub_expression, $this->emitEnforceableType());
  }

  final public function emitAssertionStatement(
    string $sub_expression,
  )[]: string {
    return
      $this->prefersStatement() ? $this->getStatementFor($sub_expression) : '';
  }

  final public function prefersStatement()[]: bool {
    return !$this->isEnforceable();
  }
}
