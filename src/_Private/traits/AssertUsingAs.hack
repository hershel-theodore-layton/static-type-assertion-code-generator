/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

trait AssertUsingAs {
  abstract const string TYPE_NAME;

  final public function emitAssertionExpression(
    VariableNamer $_variable_namer,
    string $sub_expression,
  )[write_props]: string {
    return Str\format('%s as %s', $sub_expression, static::TYPE_NAME);
  }

  final public function emitEnforceableType()[]: string {
    return static::TYPE_NAME;
  }

  final public function isEnforceable()[]: bool {
    return true;
  }
}
