/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

/**
 * Returns an unformatted Hack expression in a string.
 * This code expects to find a local variable called $htl_static_type_assertion_codegen_seed_expression.
 * The most common shell for this code is:
 * ```
 * function assert_typenamehere(mixed $htl_static_type_assertion_codegen_seed_expression): typenamehere {
 *   return <%code goes here%>;
 * }
 * ```
 */
function emit_body_for_assertion_function(
  OpaqueTypeDescription $type_desc,
): string {
  $type_desc = _Private\remove_opaqueness($type_desc);
  return $type_desc->emitAssertionExpression(
    new _Private\VariableNamer(),
    '$htl_static_type_assertion_codegen_seed_expression',
  );
}