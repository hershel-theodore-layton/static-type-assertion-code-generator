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

newtype TGenericIdentity<T> = T;
newtype TGenericMaybe<T> = ?T;
newtype TGenericNested<TValue> = TGenericIdentity<TValue>;
newtype TGenericVector<T> = vec<T>;
type TGenericTransparent<T> = TGenericIdentity<T>;

function assert_generic_nullable_identity(
  mixed $value,
)[]: TGenericIdentity<?int> {
  return $value is null ? 41 : $value as int;
}

function assert_generic_identity(mixed $value)[]: TGenericIdentity<int> {
  return $value as int;
}

function assert_generic_maybe(mixed $value)[]: TGenericMaybe<int> {
  return $value is null ? 42 : $value as int;
}

function assert_generic_nested(mixed $value)[]: TGenericNested<?int> {
  return assert_generic_nullable_identity($value);
}

function assert_generic_vector(mixed $value)[]: TGenericVector<?int> {
  $result = vec[];
  foreach (($value as vec<_>) as $element) {
    $result[] = $element as ?int;
  }
  return $result;
}

function assert_generic_dynamic(mixed $value)[]: TGenericIdentity<dynamic> {
  return $value is null ? 43 : $value as int;
}
