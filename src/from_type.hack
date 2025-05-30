/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

use namespace HTL\TypeVisitor;

function from_type<reify T>(
  dict<string, string> $type_alias_asserters,
  (function(string)[]: nothing) $panic,
  ?(function(?string, arraykey)[]: ?string) $shape_field_name_resolver = null,
  shape(?'closed_shape_suffix' => string /*_*/) $options = shape(),
)[]: OpaqueTypeDescription {
  return TypeVisitor\visit<T, _, _>(
    new DefaultVisitor(
      $type_alias_asserters,
      $panic,
      $shape_field_name_resolver ?? ($_, $_) ==> null,
      $options,
    ),
  )
    |> _Private\make_opaque($$);
}
