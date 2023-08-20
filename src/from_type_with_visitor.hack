/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

function from_type_with_visitor<reify T, Tt, Tf>(
  TypeDeclVisitor<Tt, Tf> $visitor,
)[]: Tt {
  $counter = 0;
  return \HH\ReifiedGenerics\get_type_structure<T>()
    |> _Private\clean($$)
    |> _Private\visit($visitor, $$, inout $counter);
}
