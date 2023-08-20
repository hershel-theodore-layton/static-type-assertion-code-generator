/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};

// Hopefully an alternative is found before this is removed from hhvm.
// Maybe follow what TypeAssert does?
function from_type_structure(
  CleanTypeStructure $s,
  dict<string, string> $table,
  (function(string): nothing) $panic,
): TypeDescription {
  if ($s['nullable'] ?? false) {
    $s['nullable'] = false;
    return new NullableTypeDescription(from_type_structure($s, $table, $panic));
  }

  $kind = TypeStructureKind::assert($s['kind']);
  $alias = Shapes::idx($s, 'alias');
  if ($alias is nonnull) {
    if (C\contains_key($table, $alias)) {
      return new CallThisUserSuppliedFunction(
        $table[$alias],
        // This check is a best effort.
        // We can't know if the newtype is fully opaque or if the lower bound is an arraykey.
        // This check enforces that the runtime backing type is an arraykey.
        // Hack may disagree if the lower bound is missing or a super type.
        C\contains_key(
          keyset[
            TypeStructureKind::OF_ARRAYKEY,
            TypeStructureKind::OF_ENUM,
            TypeStructureKind::OF_INT,
            TypeStructureKind::OF_STRING,
          ],
          $kind,
        ),
      );
    }
    if (Shapes::idx($s, 'opaque', false)) {
      return $panic(Str\format(
        'Could not generate typesafe code for %s. '.
        'This type is a newtype and no $type_alias_asserters entry was provided.',
        $alias,
      ));
    }
  }

  switch ($kind) {
    case TypeStructureKind::OF_ARRAY:
      return $panic('Unsupported type OF_ARRAY, use dict or vec instead');
    case TypeStructureKind::OF_ARRAYKEY:
      return new ArraykeyTypeDescription();
    case TypeStructureKind::OF_BOOL:
      return new BoolTypeDescription();
    case TypeStructureKind::OF_CLASS:
      return $panic('Unsupported type OF_CLASS');
    case TypeStructureKind::OF_DARRAY:
      return $panic('Unsupported type OF_DARRAY, use dict instead');
    case TypeStructureKind::OF_DICT:
      $generics = Shapes::at($s, 'generic_types');
      if (C\count($generics) !== 2) {
        return $panic('Malformed dict<_, _> type');
      }
      return new DictTypeDescription(
        from_type_structure(clean($generics[0]), $table, $panic),
        from_type_structure(clean($generics[1]), $table, $panic),
      );
    case TypeStructureKind::OF_DYNAMIC:
      return $panic('Unsupported type OF_DYNAMIC');
    case TypeStructureKind::OF_ENUM:
      $enum_name = Shapes::at($s, 'classname');
      if (C\contains_key($table, $enum_name)) {
        return new CallThisUserSuppliedFunction($table[$enum_name], true);
      }
      return $panic(Str\format(
        'Support for enums must be added using a $type_alias_asserters entry, got %s'.
        'See the README to learn why.',
        $enum_name,
      ));
    case TypeStructureKind::OF_FLOAT:
      return new FloatTypeDescription();
    case TypeStructureKind::OF_FUNCTION:
      return $panic('Unsupported type OF_FUNCTION');
    case TypeStructureKind::OF_GENERIC:
      return $panic('Unsupported type OF_GENERIC');
    case TypeStructureKind::OF_INT:
      return new IntTypeDescription();
    case TypeStructureKind::OF_INTERFACE:
      return $panic('Unsupported type OF_INTERFACE');
    case TypeStructureKind::OF_KEYSET:
      return new KeysetTypeDescription(
        from_type_structure(
          clean(
            C\onlyx(
              Shapes::at($s, 'generic_types'),
              'Malformed keyset<_> type',
            ),
          ),
          $table,
          $panic,
        ),
      );
    case TypeStructureKind::OF_MIXED:
      return new MixedTypeDescription();
    case TypeStructureKind::OF_NONNULL:
      return new NonnullTypeDescription();
    case TypeStructureKind::OF_NORETURN:
      return $panic('Unsupported type OF_NORETURN');
    case TypeStructureKind::OF_NOTHING:
      return $panic('Unsupported type OF_NOTHING');
    case TypeStructureKind::OF_NULL:
      return new NullTypeDescription();
    case TypeStructureKind::OF_NUM:
      return new NumTypeDescription();
    case TypeStructureKind::OF_RESOURCE:
      return $panic('Unsupported type OF_RESOURCE');
    case TypeStructureKind::OF_SHAPE:
      return new ShapeTypeDescription(
        Vec\map_with_key(
          Shapes::at($s, 'fields'),
          ($name, $t) ==> {
            $t = clean($t);
            if (!$name is string || Shapes::idx($t, 'is_cls_cns', false)) {
              return $panic(
                'Shapes with class constant keys can not be safely codegenned.',
              );
            }
            return new ShapeField(
              $name,
              string_export($name),
              $t['optional_shape_field'] ?? false,
              from_type_structure($t, $table, $panic),
            );
          },
        ),
        $s['allows_unknown_fields'] ?? false,
      );
    case TypeStructureKind::OF_STRING:
      return new StringTypeDescription();
    case TypeStructureKind::OF_TRAIT:
      return $panic('Unsupported type OF_TRAIT');
    case TypeStructureKind::OF_TUPLE:
      return new TupleTypeDescription(
        Vec\map(
          Shapes::at($s, 'elem_types'),
          $e ==> from_type_structure(clean($e), $table, $panic),
        ),
      );
    case TypeStructureKind::OF_UNRESOLVED:
      return $panic('Unsupported type OF_UNRESOLVED');
    case TypeStructureKind::OF_VARRAY:
      return $panic('Unsupported type OF_VARRAY, use vec instead');
    case TypeStructureKind::OF_VARRAY_OR_DARRAY:
      return $panic('Unsupported type OF_VARRAY_OR_DARRAY');
    case TypeStructureKind::OF_VEC:
      return new VecTypeDescription(
        from_type_structure(
          clean(
            C\onlyx(Shapes::at($s, 'generic_types'), 'Malformed vec<_> type'),
          ),
          $table,
          $panic,
        ),
      );
    case TypeStructureKind::OF_VEC_OR_DICT:
      return $panic('Unsupported type OF_VEC_OR_DICT');
    case TypeStructureKind::OF_VOID:
      return $panic('Unsupported type OF_VOID');
    case TypeStructureKind::OF_XHP:
      return $panic('Unsupported type OF_XHP');
  }
}
