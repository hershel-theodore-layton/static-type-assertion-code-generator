/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

use namespace HH\Lib\Str;

/**
 * Returns one or more statements unformatted Hack as a string.
 * The last statement will be a return statement for the specified type.
 * This code expects to find a local variable called $htl_untyped_variable.
 * The most common shell for this code is:
 * ```
 * function assert_typenamehere(mixed $htl_untyped_variable): typenamehere {
 *   <%code goes here%>
 * }
 * ```
 */
function emit_body_for_assertion_function(
  OpaqueTypeDescription $type_desc,
)[write_props]: string {
  $expression = _Private\remove_opaqueness($type_desc)->emitAssertionExpression(
    new _Private\VariableNamer(),
    '$htl_untyped_variable',
  );

  if (Str\starts_with($expression, '() ==> { ')) {
    // Boil away the outer iife.
    return Str\strip_prefix($expression, '() ==> { ')
      |> Str\strip_suffix($$, ' }()');
  } else {
    // Turn expression into a statement.
    return 'return '.$expression.';';
  }
}
