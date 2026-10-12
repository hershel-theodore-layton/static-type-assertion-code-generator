/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

use namespace HTL\TypeVisitor;

function from_type<reify T>(
  dict<string, string> $type_alias_asserters,
  (function(string)[]: nothing) $panic,
  ?(function(?string, arraykey)[]: ?string) $shape_field_name_resolver = null,
  shape(
    ?'closed_shape_suffix' => string,
    ?'assertion_resolver' => ?(function(
      TypeVisitor\TAlias,
      dict<string, string>,
    )[]: ?string),
    /*_*/
  ) $options = shape(),
)[]: OpaqueTypeDescription {
  $specialization = $options['assertion_resolver'] ?? ($_, $_)[] ==> null;
  return TypeVisitor\visit<T, _, _>(
    new DefaultVisitor(
      _Private\make_assertion_resolver($type_alias_asserters, $specialization),
      $panic,
      $shape_field_name_resolver ?? ($_, $_) ==> null,
      shape('closed_shape_suffix' => $options['closed_shape_suffix'] ?? ''),
    ),
  )
    |> _Private\make_opaque($$);
}
