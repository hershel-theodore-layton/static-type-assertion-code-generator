/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

// Built-in as https://github.com/facebook/hhvm/blob/master/hphp/hack/hhi/typestructure.hhi
// This can not be used portably, because of hadva.
// Removed classname-ness to classname, since this can not be asserted.
type TypelessTypeStructure = shape(
  ?'nullable' => ?bool,
  'kind' => int,
  ?'name' => string,
  ?'classname' => string,
  ?'elem_types' => KeyedContainer<int, mixed>,
  ?'return_type' => KeyedContainer<arraykey, mixed>,
  ?'param_types' => KeyedContainer<int, mixed>,
  ?'generic_types' => KeyedContainer<int, mixed>,
  ?'root_name' => ?string,
  ?'access_list' => KeyedContainer<int, mixed>,
  ?'fields' => KeyedContainer<arraykey, mixed>,
  ?'allows_unknown_fields' => ?bool,
  ?'is_cls_cns' => bool,
  ?'optional_shape_field' => ?bool,
  ?'value' => KeyedContainer<arraykey, mixed>,
  ?'typevars' => string,
  ?'alias' => string,
  ?'exact' => bool,
  ?'like' => bool,
);
