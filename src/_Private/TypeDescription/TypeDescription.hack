/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

// Do not implement this interface outside of this package.
// It is private to this package.
interface TypeDescription {
  // Can this type appear on the RHS of an as expression?
  public function isEnforceable()[]: bool;

  // Given `$sub_expression`, emit a fully sound assertion.
  public function emitAssertionExpression(
    VariableNamer $variable_namer,
    string $sub_expression,
  )[write_props]: string;

  // Emit the RHS of an `as` expression.
  // Fails if not `->isEnforceable()`.
  public function emitEnforceableType()[]: string;

  // For bypassing upperbound key checks on dict and keyset.
  public function exactlyArraykey()[]: bool;

  // For bypassing upperbound value checks in arrays.
  public function exactlyMixed()[]: bool;

  // For upholding key type variance on construction of dict and keyset.
  public function subtypeOfArraykey()[]: bool;

  // For upholding Hack's nullability rules in as expressions.
  // `as ?mixed` is disallowed, so it `?null` and `??int`
  public function superTypeOfNull()[]: bool;
}
