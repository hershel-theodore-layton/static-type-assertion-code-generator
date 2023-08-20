/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\Str;

function format_statements(string ...$stmts)[]: string {
  return Str\join($stmts, ' ') |> $$ !== '' ? $$.' ' : $$;
}
