/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

use namespace HH\Lib\{Str, Vec};

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
)[]: string {
  $type_desc = _Private\remove_opaqueness($type_desc);

  $statement = $type_desc->emitAssertionStatement('$htl_untyped_variable');
  $expression =
    'return '.$type_desc->emitAssertionExpression('$htl_untyped_variable').';';

  return Vec\filter(vec[$statement, $expression]) |> Str\join($$, ' ');
}
