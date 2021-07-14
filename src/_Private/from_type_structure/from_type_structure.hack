/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Vec};

// Hopefully an alternative is found before this is removed from hhvm.
// Maybe follow what TypeAssert does?
function from_type_structure(TypelessTypeStructure $s): TypeDescription {
  if ($s['nullable'] ?? false) {
    $s['nullable'] = false;
    return new NullableTypeDescription(from_type_structure($s));
  }

  invariant(
    $s['kind'] is TypeStructureKind,
    'Type %d is not present in the TypeStructure enum and therefore not supported',
    $s['kind'],
  );

  switch ($s['kind']) {
    case TypeStructureKind::OF_ARRAY:
      invariant_violation('Unsupported type OF_ARRAY, use dict or vec instead');
    case TypeStructureKind::OF_ARRAYKEY:
      return new ArraykeyTypeDescription();
    case TypeStructureKind::OF_BOOL:
      return new BoolTypeDescription();
    case TypeStructureKind::OF_CLASS:
      invariant_violation('Unsupported type OF_CLASS');
    case TypeStructureKind::OF_DARRAY:
      invariant_violation('Unsupported type OF_DARRAY, use dict instead');
    case TypeStructureKind::OF_DICT:
      $generics = Shapes::at($s, 'generic_types');
      invariant(C\count($generics) === 2, 'Malformed dict<_, _> type');
      return new DictTypeDescription(
        from_type_structure(assert_typeless_type_structure($generics[0])),
        from_type_structure(assert_typeless_type_structure($generics[1])),
      );
    case TypeStructureKind::OF_DYNAMIC:
      invariant_violation('Unsupported type OF_DYNAMIC');
    case TypeStructureKind::OF_ENUM:
      invariant_violation('Unsupported type OF_ENUM');
    case TypeStructureKind::OF_FLOAT:
      return new FloatTypeDescription();
    case TypeStructureKind::OF_FUNCTION:
      invariant_violation('Unsupported type OF_FUNCTION');
    case TypeStructureKind::OF_GENERIC:
      invariant_violation('Unsupported type OF_GENERIC');
    case TypeStructureKind::OF_INT:
      return new IntTypeDescription();
    case TypeStructureKind::OF_INTERFACE:
      invariant_violation('Unsupported type OF_INTERFACE');
    case TypeStructureKind::OF_KEYSET:
      return new KeysetTypeDescription(
        from_type_structure(
          assert_typeless_type_structure(
            C\onlyx(
              Shapes::at($s, 'generic_types'),
              'Malformed keyset<_> type',
            ),
          ),
        ),
      );
    case TypeStructureKind::OF_MIXED:
      return new MixedTypeDescription();
    case TypeStructureKind::OF_NONNULL:
      return new NonnullTypeDescription();
    case TypeStructureKind::OF_NORETURN:
      invariant_violation('Unsupported type OF_NORETURN');
    case TypeStructureKind::OF_NOTHING:
      invariant_violation('Unsupported type OF_NOTHING');
    case TypeStructureKind::OF_NULL:
      return new NullTypeDescription();
    case TypeStructureKind::OF_NUM:
      return new NumTypeDescription();
    case TypeStructureKind::OF_RESOURCE:
      invariant_violation('Unsupported type OF_RESOURCE');
    case TypeStructureKind::OF_SHAPE:
      return new ShapeTypeDescription(
        Vec\map_with_key(
          Shapes::at($s, 'fields'),
          ($name, $t) ==> {
            $t = assert_typeless_type_structure($t);
            invariant(
              $name is string && !Shapes::idx($t, 'is_cls_cns', false),
              'Class constants a shape keys are not supported.',
            );
            return new ShapeField(
              $name,
              $t['optional_shape_field'] ?? false,
              from_type_structure($t),
            );
          },
        ),
        $s['allows_unknown_fields'] ?? false,
      );
    case TypeStructureKind::OF_STRING:
      return new StringTypeDescription();
    case TypeStructureKind::OF_TRAIT:
      invariant_violation('Unsupported type OF_TRAIT');
    case TypeStructureKind::OF_TUPLE:
      return new TupleTypeDescription(
        Vec\map(
          Shapes::at($s, 'elem_types'),
          $e ==> from_type_structure(assert_typeless_type_structure($e)),
        ),
      );
    case TypeStructureKind::OF_UNRESOLVED:
      invariant_violation('Unsupported type OF_UNRESOLVED');
    case TypeStructureKind::OF_VARRAY:
      invariant_violation('Unsupported type OF_VARRAY, use vec instead');
    case TypeStructureKind::OF_VARRAY_OR_DARRAY:
      invariant_violation('Unsupported type OF_VARRAY_OR_DARRAY');
    case TypeStructureKind::OF_VEC:
      return new VecTypeDescription(
        from_type_structure(
          assert_typeless_type_structure(
            C\onlyx(Shapes::at($s, 'generic_types'), 'Malformed vec<_> type'),
          ),
        ),
      );
    case TypeStructureKind::OF_VEC_OR_DICT:
      invariant_violation('Unsupported type OF_VEC_OR_DICT');
    case TypeStructureKind::OF_VOID:
      invariant_violation('Unsupported type OF_VOID');
    case TypeStructureKind::OF_XHP:
      invariant_violation('Unsupported type OF_XHP');
  }

  invariant_violation('kaboom');
}
