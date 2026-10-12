/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH;
use namespace HH\Lib\Str;
use type HH\Shapes;
use type HTL\TypeVisitor\TAlias;
use type ReflectionException, ReflectionTypeAlias;

function make_assertion_resolver(
  dict<string, string> $asserters,
  (function(TAlias, dict<string, string>)[]: ?string) $specialization,
)[]: (function(
  TAlias,
  ?string,
)[]: ?shape('assert' => string, 'nullable' => bool /*_*/)) {
  return ($alias, $fallback_name)[] ==>
    find_asserter($alias, $fallback_name, $asserters, $specialization);
}

function find_asserter(
  TAlias $alias,
  ?string $fallback_name,
  dict<string, string> $asserters,
  (function(TAlias, dict<string, string>)[]: ?string) $specialization,
)[]: ?shape('assert' => string, 'nullable' => bool /*_*/) {
  while (true) {
    $name = $alias['alias'];
    if ($name is null) {
      if ($fallback_name is null) {
        return null;
      }
      $name = $fallback_name;
      $fallback_name = null;
      $alias = shape(
        'alias' => $name,
        'counter' => $alias['counter'],
        'opaque' => false,
      );
    }
    if ($name === $fallback_name) {
      $fallback_name = null;
    }

    $asserter = $specialization($alias, $asserters) ?? idx($asserters, $name);
    if ($asserter is nonnull) {
      $nullable_arguments = dict[];
      foreach (($alias['typevar_types'] ?? dict[]) as $parameter => $argument) {
        $nullable_arguments[$parameter] =
          type_accepts_null($argument as dict<_, _>, dict[]);
      }
      return shape(
        'assert' => $asserter,
        'nullable' => type_accepts_null(
          reflect_alias($name) ?? dict[],
          $nullable_arguments,
        ),
      );
    }

    $type = reflect_alias($name);
    // Each opaque alias needs its own upcast, even if an inner handler exists.
    if (($type['opaque'] ?? false) === true) {
      return null;
    }
    $inner_name = $type['classname'] ?? null;
    $inner_name = $inner_name as ?string;
    if ($inner_name is null) {
      $alias['alias'] = null;
      continue;
    }

    $arguments = inner_type_arguments(
      $inner_name,
      $type as nonnull,
      $alias['typevar_types'] ?? dict[],
    );
    $alias['alias'] = $inner_name;
    $alias['opaque'] = (reflect_alias($inner_name)['opaque'] ?? false) === true;
    Shapes::removeKey(inout $alias, 'typevar_types');
    if ($arguments !== dict[]) {
      $alias['typevar_types'] = $arguments;
    }
  }
}

function inner_type_arguments(
  string $name,
  dict<arraykey, mixed> $type,
  KeyedContainer<string, mixed> $arguments,
)[]: dict<string, mixed> {
  $parameters = reflect_alias($name)['typevars'] ?? '';
  if ($parameters === '') {
    return dict[];
  }
  $parameters = Str\split($parameters as string, ',');
  $types = ($type['generic_types'] ?? vec[]) as KeyedContainer<_, _>;
  $result = dict[];
  foreach ($parameters as $index => $parameter) {
    $argument = $types[$index] ?? null;
    if ($argument is nonnull) {
      $result[$parameter] = substitute_type_arguments($argument, $arguments);
    }
  }
  return $result;
}

function substitute_type_arguments(
  mixed $type,
  KeyedContainer<string, mixed> $arguments,
)[]: mixed {
  if ($type is dict<_, _>) {
    if (($type['kind'] ?? null) === HH\TypeStructureKind::OF_GENERIC) {
      $name = $type['name'] ?? null;
      $argument = $name is string ? idx($arguments, $name) : null;
      if ($argument is nonnull) {
        $argument = $argument as dict<_, _>;
        if (($type['nullable'] ?? false) === true) {
          $argument['nullable'] = true;
        }
        return $argument;
      }
    }
    $result = dict[];
    foreach ($type as $key => $value) {
      $result[$key] = substitute_type_arguments($value, $arguments);
    }
    return $result;
  }
  if ($type is vec<_>) {
    $result = vec[];
    foreach ($type as $value) {
      $result[] = substitute_type_arguments($value, $arguments);
    }
    return $result;
  }
  return $type;
}

function type_accepts_null(
  dict<arraykey, mixed> $type,
  dict<string, bool> $arguments,
)[]: bool {
  if (($type['nullable'] ?? false) === true) {
    return true;
  }

  switch ($type['kind'] ?? null) {
    case HH\TypeStructureKind::OF_NULL:
    case HH\TypeStructureKind::OF_MIXED:
    case HH\TypeStructureKind::OF_DYNAMIC:
      return true;
    case HH\TypeStructureKind::OF_GENERIC:
      $parameter = $type['name'] ?? null;
      return $parameter is string && ($arguments[$parameter] ?? false);
    case HH\TypeStructureKind::OF_UNRESOLVED:
      $name = $type['classname'] ?? null;
      if (!$name is string) {
        return false;
      }
      return type_accepts_null(
        reflect_alias($name) ?? dict[],
        inner_nullable_arguments($name, $type, $arguments),
      );
    default:
      return false;
  }
}

function inner_nullable_arguments(
  string $name,
  dict<arraykey, mixed> $type,
  dict<string, bool> $arguments,
)[]: dict<string, bool> {
  $parameters = reflect_alias($name)['typevars'] ?? '';
  $parameters = Str\split($parameters as string, ',');
  $types = $type['generic_types'] ?? vec[];
  $types = $types as KeyedContainer<_, _>;
  $result = dict[];
  foreach ($parameters as $index => $parameter) {
    $argument = $types[$index] ?? null;
    if ($argument is nonnull) {
      $result[$parameter] =
        type_accepts_null($argument as dict<_, _>, $arguments);
    }
  }
  return $result;
}

function reflect_alias(string $name)[]: ?dict<arraykey, mixed> {
  try {
    return new ReflectionTypeAlias($name)
      |> $$->getTypeStructure();
  } catch (ReflectionException $_) {
    return null;
  }
}
