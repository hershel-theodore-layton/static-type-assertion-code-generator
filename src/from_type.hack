/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

function from_type<reify T>(
  dict<string, string> $type_alias_asserters,
  (function(string): nothing) $panic,
): OpaqueTypeDescription {
  return \HH\ReifiedGenerics\get_type_structure<T>()
    |> _Private\clean_type_structure($$)
    |> _Private\from_type_structure($$, $type_alias_asserters, $panic)
    |> _Private\make_opaque($$);
}
