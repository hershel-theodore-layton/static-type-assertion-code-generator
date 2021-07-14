/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

// Workaround for constants in traits, supported since 4.97.
interface MustHaveTypenameConstant {
  abstract const string TYPE_NAME;
}

trait AssertUsingAs {
  require implements MustHaveTypenameConstant;

  final public function emitAssertionExpression(
    VariableNamer $_variable_namer,
    string $sub_expression,
  ): string {
    return Str\format('%s as %s', $sub_expression, static::TYPE_NAME);
  }

  final public function emitEnforceableType(): string {
    return static::TYPE_NAME;
  }

  final public function isEnforceable(): bool {
    return true;
  }
}
