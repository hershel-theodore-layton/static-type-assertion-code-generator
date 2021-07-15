/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

function assert_typeless_type_structure(
  mixed $htl_static_type_assertion_codegen_seed_expression,
): TypelessTypeStructure {
  return () ==> {
    $partial__0 = $htl_static_type_assertion_codegen_seed_expression as shape(
      ?'access_list' => KeyedContainer<_, _>,
      ?'alias' => string,
      ?'allows_unknown_fields' => ?bool,
      ?'classname' => string,
      ?'elem_types' => KeyedContainer<_, _>,
      ?'exact' => bool,
      ?'fields' => KeyedContainer<_, _>,
      ?'generic_types' => KeyedContainer<_, _>,
      ?'is_cls_cns' => bool,
      'kind' => int,
      ?'like' => bool,
      ?'name' => string,
      ?'nullable' => ?bool,
      ?'optional_shape_field' => ?bool,
      ?'param_types' => KeyedContainer<_, _>,
      ?'return_type' => KeyedContainer<_, _>,
      ?'root_name' => ?string,
      ?'typevars' => string,
      ?'value' => KeyedContainer<_, _>,
    );

    // Erase hadva-ness
    if (Shapes::keyExists($partial__0, 'elem_types')) {
      invariant(
        \HH\is_vec_or_varray($partial__0['elem_types']),
        'Can not safely cast to vec',
      );
      $partial__0['elem_types'] = vec($partial__0['elem_types']);
    } else {
      Shapes::removeKey(inout $partial__0, 'elem_types');
    }
    if (Shapes::keyExists($partial__0, 'return_type')) {
      invariant(
        \HH\is_dict_or_darray($partial__0['return_type']),
        'Can not safely cast to dict',
      );
      $partial__0['return_type'] = infer_keytype_arraykey(
        dict($partial__0['return_type']),
      );
    } else {
      Shapes::removeKey(inout $partial__0, 'return_type');
    }
    if (Shapes::keyExists($partial__0, 'param_types')) {
      invariant(
        \HH\is_vec_or_varray($partial__0['param_types']),
        'Can not safely cast to vec',
      );
      $partial__0['param_types'] = vec($partial__0['param_types']);
    } else {
      Shapes::removeKey(inout $partial__0, 'param_types');
    }
    if (Shapes::keyExists($partial__0, 'generic_types')) {
      invariant(
        \HH\is_vec_or_varray($partial__0['generic_types']),
        'Can not safely cast to vec',
      );
      $partial__0['generic_types'] = vec($partial__0['generic_types']);
    } else {
      Shapes::removeKey(inout $partial__0, 'generic_types');
    }
    if (Shapes::keyExists($partial__0, 'access_list')) {
      invariant(
        \HH\is_vec_or_varray($partial__0['access_list']),
        'Can not safely cast to vec',
      );
      $partial__0['access_list'] = vec($partial__0['access_list']);
    } else {
      Shapes::removeKey(inout $partial__0, 'access_list');
    }
    if (Shapes::keyExists($partial__0, 'fields')) {
      invariant(
        \HH\is_dict_or_darray($partial__0['fields']),
        'Can not safely cast to dict',
      );
      $partial__0['fields'] = infer_keytype_arraykey(
        dict($partial__0['fields']),
      );
    } else {
      Shapes::removeKey(inout $partial__0, 'fields');
    }
    if (Shapes::keyExists($partial__0, 'value')) {
      invariant(
        \HH\is_dict_or_darray($partial__0['value']),
        'Can not safely cast to dict',
      );
      $partial__0['value'] = infer_keytype_arraykey(dict($partial__0['value']));
    } else {
      Shapes::removeKey(inout $partial__0, 'value');
    }
    return $partial__0;
  }();
}
