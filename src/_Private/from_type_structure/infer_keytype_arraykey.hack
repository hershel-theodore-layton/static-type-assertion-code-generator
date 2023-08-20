/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

function infer_keytype_arraykey(
  dict<arraykey, mixed> $d,
)[]: dict<arraykey, mixed> {
  return $d;
}
