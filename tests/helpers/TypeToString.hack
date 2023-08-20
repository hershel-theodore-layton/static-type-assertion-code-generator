/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str};
use type HTL\StaticTypeAssertionCodegen\{TAlias, TypeDeclVisitor};
use function HTL\StaticTypeAssertionCodegen\_Private\string_export;

final class TypeToString implements TypeDeclVisitor<string, string> {
  public function panic(string $message)[]: nothing {
    return panic($message);
  }

  public function unsupportedType(string $type_name)[]: nothing {
    return panic($type_name);
  }

  public function shapeField(
    ?string $_parent_shape_name,
    arraykey $key,
    bool $_is_class_constant,
    bool $is_optional,
    string $type,
  )[]: string {
    return Str\format(
      '%s%s => %s',
      $is_optional ? '?' : '',
      $key is string ? string_export($key) : (string)$key,
      $type,
    );
  }

  public function arraykey(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'arraykey';
  }

  public function bool(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'bool';
  }

  public function dict(TAlias $alias, string $key, string $value)[]: string {
    return $alias['alias'] ?? Str\format('dict<%s, %s>', $key, $value);
  }

  public function enum(TAlias $alias, string $classname)[]: string {
    return $alias['alias'] ?? $classname;
  }

  public function float(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'float';
  }

  public function int(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'int';
  }

  public function keyset(TAlias $alias, string $inner)[]: string {
    return $alias['alias'] ?? Str\format('keyset<%s>', $inner);
  }

  public function mixed(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'mixed';
  }

  public function nonnull(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'nonnull';
  }

  public function null(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'null';
  }

  public function nullable(TAlias $alias, string $inner)[]: string {
    return $alias['alias'] ?? ('?'.$inner);
  }

  public function num(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'num';
  }

  public function shape(
    TAlias $alias,
    vec<string> $fields,
    bool $is_open,
  )[]: string {
    return $alias['alias'] ??
      (
        Str\join($fields, ', ')
        |> $is_open ? (C\is_empty($fields) ? $$.'...' : $$.', ...') : $$
        |> Str\format('shape(%s)', $$)
      );
  }

  public function string(TAlias $alias)[]: string {
    return $alias['alias'] ?? 'string';
  }

  public function tuple(TAlias $alias, vec<string> $elements)[]: string {
    return $alias['alias'] ?? Str\format('(%s)', Str\join($elements, ', '));
  }

  public function vec(TAlias $alias, string $inner)[]: string {
    return $alias['alias'] ?? Str\format('vec<%s>', $inner);
  }

  public function vecOfDict(TAlias $alias, vec<string> $inner)[]: string {
    return
      $alias['alias'] ?? Str\format('vec_or_dict<%s>', Str\join($inner, ', '));
  }
}
