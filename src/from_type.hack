/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

function from_type<reify T>(
  dict<string, string> $type_alias_asserters,
  (function(string)[]: nothing) $panic,
)[]: OpaqueTypeDescription {
  return from_type_with_visitor<T, _, _>(
    new DefaultVisitor($type_alias_asserters, $panic),
  )
    |> _Private\make_opaque($$);
}
