/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

newtype TBoundaryInner = int;
type TBoundaryTransparentInner = TBoundaryInner;
newtype TBoundaryOuter = TBoundaryInner;
newtype TBoundaryOuterViaTransparent = TBoundaryTransparentInner;
type TBoundaryTransparentOuter = TBoundaryOuter;
type TBoundaryLongChain = TBoundaryTransparentOuter;
type TBoundaryNullableOuter = ?TBoundaryOuter;
newtype TBoundaryNullable = ?TBoundaryInner;

function assert_boundary_inner(mixed $value)[]: TBoundaryInner {
  return $value as int;
}

function assert_boundary_outer(mixed $value)[]: TBoundaryOuter {
  return assert_boundary_inner($value);
}
