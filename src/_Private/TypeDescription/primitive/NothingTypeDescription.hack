/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

final class NothingTypeDescription implements TypeDescription {
  public function isAssertable(): bool {
    return false;
  }

  public function isEnforceable(): bool {
    return false;
  }

  public function emitEnforceableType(): string {
    invariant_violation('`nothing` ceised to be enforceable in hhvm 4.100');
  }

  public function emitAssertionExpression(
    VariableNamer $_variable_namer,
    string $_sub_expression,
  ): string {
    return Str\format(
      "(): nothing ==> { throw new \\TypeAssertionException('Expected nothing, got something'); }()",
    );
  }

  public function exactlyArraykey(): bool {
    return false;
  }

  public function exactlyMixed(): bool {
    return false;
  }

  public function subtypeOfArraykey(): bool {
    return true;
  }

  public function superTypeOfNull(): bool {
    return true;
  }
}
