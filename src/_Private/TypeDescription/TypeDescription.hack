/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

// Do not implement this interface outside of this package.
// It is private to this package.
interface TypeDescription {
  // Can this type appear on the RHS of an as expression?
  public function isEnforceable()[]: bool;

  // Given `$sub_expression`, emit a fully sound assertion.
  // If doing so would require an inline lambda,
  // return the name of your `$tmp__x` variable.
  public function emitAssertionExpression(string $sub_expression)[]: string;

  // Given `$sub_expression`, emit a fully sound assertion.
  // If emitting an expression in place is as cheap as emitting a statement,
  // return an empty string.
  public function emitAssertionStatement(string $sub_expression)[]: string;

  // Emit the RHS of an `as` expression.
  // Fails if not `->isEnforceable()`.
  public function emitEnforceableType()[]: string;

  // For bypassing upperbound key checks on dict and keyset.
  public function exactlyArraykey()[]: bool;

  // For bypassing upperbound value checks in arrays.
  public function exactlyMixed()[]: bool;

  // For upholding key type variance on construction of dict and keyset.
  public function subtypeOfArraykey()[]: bool;

  // Return a unique variable name with a given prefix.
  public function suffixVariable(string $name)[]: string;

  // For upholding Hack's nullability rules in as expressions.
  // `as ?mixed` is disallowed, so it `?null` and `??int`
  public function superTypeOfNull()[]: bool;

  // Some types are faster to assert in a statement compared to an expression.
  // Such a type prefers to be asserted in a statement.
  public function prefersStatement()[]: bool;
}
