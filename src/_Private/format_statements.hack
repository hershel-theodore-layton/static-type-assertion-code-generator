/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{Str, Vec};

function format_statements(string ...$stmts)[]: string {
  return Vec\filter($stmts) |> Str\join($$, " \n") |> $$ !== '' ? $$.' ' : $$;
}
