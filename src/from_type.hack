/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

function from_type<reify T>(): OpaqueTypeDescription {
  return \HH\ReifiedGenerics\get_type_structure<T>()
    |> _Private\assert_typeless_type_structure($$)
    |> _Private\from_type_structure($$)
    |> _Private\make_opaque($$);
}
