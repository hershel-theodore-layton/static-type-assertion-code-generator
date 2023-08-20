/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

type TAlias = shape(
  'alias' => ?string,
  'counter' => int,
  'opaque' => bool,
);