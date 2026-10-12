/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

use namespace HH;
use namespace HH\Lib\{C, Str};
use type HTL\TypeVisitor\TAlias;
use type ReflectionException, ReflectionTypeAlias;

function make_assertion_resolver(
  dict<string, string> $asserters,
  (function(TAlias, dict<string, string>)[]: ?string) $specialization,
)[]: (function(
  TAlias,
)[]: ?shape('assert' => string, 'nullable' => bool /*_*/)) {
  return ($alias)[] ==> find_asserter($alias, $asserters, $specialization);
}

function find_asserter(
  TAlias $alias,
  dict<string, string> $asserters,
  (function(TAlias, dict<string, string>)[]: ?string) $specialization,
)[]: ?shape('assert' => string, 'nullable' => bool/*_*/) {
  $name = $alias['alias'];
  if ($name is null) {
    return null;
  }
  $resolved_asserter = $specialization($alias, $asserters);
  $type_arguments = $alias['typevar_types'] ?? dict[];
  $nullable_arguments = dict[];
  foreach ($type_arguments as $parameter => $argument) {
    $nullable_arguments[$parameter] =
      type_accepts_null($argument as dict<_, _>, dict[]);
  }

  while (
    $resolved_asserter is null &&
    $name !== null &&
    !C\contains_key($asserters, $name)
  ) {
    $type = reflect_alias($name);
    $inner_name = try_get_inner_alias($name);
    $nullable_arguments = $inner_name is null || $type is null
      ? dict[]
      : inner_nullable_arguments($inner_name, $type, $nullable_arguments);
    $name = $inner_name;
  }

  $asserter = $resolved_asserter ?? idx($asserters, $name);

  if ($asserter is null || $name is null) {
    return null;
  }

  return shape(
    'assert' => $asserter,
    'nullable' =>
      type_accepts_null(reflect_alias($name) ?? dict[], $nullable_arguments),
  );
}

function try_get_inner_alias(string $name)[]: ?string {
  $type = reflect_alias($name);
  // Transparent aliases may forward to a handler, but each newtype needs
  // its own upcast, even when its underlying type has a handler.
  if (($type['opaque'] ?? false) === true) {
    return null;
  }
  return $type['classname'] ?? null |> $$ as ?string;
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
