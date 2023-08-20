/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH\Lib\{C, Str, Vec};
use type HTL\StaticTypeAssertionCodegen\TypeDeclVisitor;

// Hopefully an alternative is found before this is removed from hhvm.
// Maybe follow what TypeAssert does?
function visit<Tt, Tf>(
  TypeDeclVisitor<Tt, Tf> $visitor,
  CleanTypeStructure $s,
  inout int $counter,
)[]: Tt {
  ++$counter;
  $kind = TypeStructureKind::assert($s['kind']);
  $alias = shape(
    'alias' => $s['alias'] ?? null,
    'counter' => $counter,
    'opaque' => $s['opaque'] ?? false,
  );

  if ($s['nullable'] ?? false) {
    $s['nullable'] = false;
    return $visitor->nullable($alias, visit($visitor, $s, inout $counter));
  }

  switch ($kind) {
    case TypeStructureKind::OF_ARRAY:
      return
        $visitor->panic('Unsupported type OF_ARRAY, use dict or vec instead');
    case TypeStructureKind::OF_ARRAYKEY:
      return $visitor->arraykey($alias);
    case TypeStructureKind::OF_BOOL:
      return $visitor->bool($alias);
    case TypeStructureKind::OF_CLASS:
      return $visitor->panic('Unsupported type OF_CLASS');
    case TypeStructureKind::OF_DARRAY:
      return $visitor->panic('Unsupported type OF_DARRAY, use dict instead');
    case TypeStructureKind::OF_DICT:
      $generics = $s['generic_types'] ?? vec[];
      if (C\count($generics) !== 2) {
        return $visitor->panic('Malformed dict<_, _> type');
      }
      return $visitor->dict(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
        visit($visitor, clean($generics[1]), inout $counter),
      );
    case TypeStructureKind::OF_DYNAMIC:
      return $visitor->panic('Unsupported type OF_DYNAMIC');
    case TypeStructureKind::OF_ENUM:
      $enum_name = $s['classname'] ?? null;

      if ($enum_name is null) {
        return $visitor->panic('Enum without classname.');
      }

      return $visitor->enum($alias, $enum_name);
    case TypeStructureKind::OF_FLOAT:
      return $visitor->float($alias);
    case TypeStructureKind::OF_FUNCTION:
      return $visitor->panic('Unsupported type OF_FUNCTION');
    case TypeStructureKind::OF_GENERIC:
      return $visitor->panic('Unsupported type OF_GENERIC');
    case TypeStructureKind::OF_INT:
      return $visitor->int($alias);
    case TypeStructureKind::OF_INTERFACE:
      return $visitor->panic('Unsupported type OF_INTERFACE');
    case TypeStructureKind::OF_KEYSET:
      $generics = $s['generic_types'] ?? vec[];

      if (C\count($generics) !== 1) {
        return $visitor->panic(
          Str\format('Keyset type with %d type parameters', C\count($generics)),
        );
      }

      return $visitor->keyset(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
      );
    case TypeStructureKind::OF_MIXED:
      return $visitor->mixed($alias);
    case TypeStructureKind::OF_NONNULL:
      return $visitor->nonnull($alias);
    case TypeStructureKind::OF_NORETURN:
      return $visitor->panic('Unsupported type OF_NORETURN');
    case TypeStructureKind::OF_NOTHING:
      return $visitor->panic('Unsupported type OF_NOTHING');
    case TypeStructureKind::OF_NULL:
      return $visitor->null($alias);
    case TypeStructureKind::OF_NUM:
      return $visitor->num($alias);
    case TypeStructureKind::OF_RESOURCE:
      return $visitor->panic('Unsupported type OF_RESOURCE');
    case TypeStructureKind::OF_SHAPE:
      $fields = $s['fields'] ?? null;

      if ($fields is null) {
        return $visitor->panic('Shape without field information.');
      }

      return $visitor->shape(
        $alias,
        Vec\map_with_key($fields, ($name, $t) ==> {
          $t = clean($t);
          $const = $t['is_cls_cns'] ?? false;
          $optional = $t['optional_shape_field'] ?? false;

          return $visitor->shapeField(
            $alias['alias'],
            $name,
            $const,
            $optional,
            visit($visitor, $t, inout $counter),
          );
        }),
        $s['allows_unknown_fields'] ?? false,
      );

    case TypeStructureKind::OF_STRING:
      return $visitor->string($alias);
    case TypeStructureKind::OF_TRAIT:
      return $visitor->panic('Unsupported type OF_TRAIT');
    case TypeStructureKind::OF_TUPLE:
      $generics = $s['elem_types'] ?? vec[];

      if (C\is_empty($generics)) {
        return $visitor->panic('Tuple without type parameters.');
      }

      return $visitor->tuple(
        $alias,
        Vec\map($generics, $g ==> visit($visitor, clean($g), inout $counter)),
      );
    case TypeStructureKind::OF_UNRESOLVED:
      return $visitor->panic('Unsupported type OF_UNRESOLVED');
    case TypeStructureKind::OF_VARRAY:
      return $visitor->panic('Unsupported type OF_VARRAY, use vec instead');
    case TypeStructureKind::OF_VARRAY_OR_DARRAY:
      return $visitor->panic('Unsupported type OF_VARRAY_OR_DARRAY');
    case TypeStructureKind::OF_VEC:
      $generics = $s['generic_types'] ?? vec[];

      if (C\count($generics) !== 1) {
        return $visitor->panic(
          Str\format('Vec type with %d type parameters', C\count($generics)),
        );
      }

      return $visitor->vec(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
      );
    case TypeStructureKind::OF_VEC_OR_DICT:
      return $visitor->panic('Unsupported type OF_VEC_OR_DICT');
    case TypeStructureKind::OF_VOID:
      return $visitor->panic('Unsupported type OF_VOID');
    case TypeStructureKind::OF_XHP:
      return $visitor->panic('Unsupported type OF_XHP');
  }
}
