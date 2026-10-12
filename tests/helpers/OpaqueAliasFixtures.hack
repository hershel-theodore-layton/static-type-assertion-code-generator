/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type stdClass;

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

newtype TSpecializedBox<T> = shape('value' => T /*_*/);
type TSpecializedPair = (TSpecializedBox<int>, TSpecializedBox<string>);
type TSpecializedNested = vec<TSpecializedPair>;

function assert_int_box(mixed $value)[]: TSpecializedBox<int> {
  return
    shape('value' => ($value as shape('value' => mixed /*_*/))['value'] as int);
}

function assert_string_box(mixed $value)[]: TSpecializedBox<string> {
  return shape(
    'value' => ($value as shape('value' => mixed /*_*/))['value'] as string,
  );
}

type TSpecializedIntBox = TSpecializedBox<int>;

function assert_nullable_int_box(mixed $value)[]: TSpecializedBox<?int> {
  return shape(
    'value' => ($value as shape('value' => mixed /*_*/))['value'] as ?int,
  );
}

type TResolverClassAlias = stdClass;
newtype TResolverOpaqueClass = stdClass;
type TResolverInner<TItem> = TSpecializedBox<TItem>;
type TResolverMiddle<TValue> = TResolverInner<vec<TValue>>;
type TResolverOuter<T> = TResolverMiddle<T>;
type TResolverNullable<T> = TGenericTransparent<?T>;

function assert_resolver_class(mixed $value)[]: stdClass {
  return $value as stdClass;
}

function assert_vector_int_box(mixed $value)[]: TSpecializedBox<vec<int>> {
  $result = vec[];
  foreach (
    (($value as shape('value' => mixed /*_*/))['value'] as vec<_>) as $item
  ) {
    $result[] = $item as int;
  }
  return shape('value' => $result);
}
