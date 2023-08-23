/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str, Vec};
use namespace HTL\{StaticTypeAssertionCodegen, TypeVisitor};
use function HTL\StaticTypeAssertionCodegen\_Private\hackfmt;

/**
 * Note to self, this file is not formatted by hackfmt,
 * hackfmt sees at-sign-generated and leaves this file alone.
 */
final class CodegenHelper implements \IDisposable {
  const string CODEGEN_BASE = __DIR__.'/../codegen/';
  const type TMethods = dict<string, shape('body' => string, 'type' => string)>;

  private this::TMethods $methods = dict[];
  private string $file;

  public function __construct(
    private string $codegenTargetClass,
    private (function(this::TMethods): void) $storeMethods,
  ) {
    $this->file = static::CODEGEN_BASE.$codegenTargetClass.'.generated.hack';
  }

  public function createMethod<reify T>(
    string $name,
    dict<string, string> $table = dict[],
    ?(function(?string, arraykey)[]: ?string) $shape_field_name_resolver = null,
  ): void {
    invariant(
      !C\contains_key($this->methods, $name),
      'Method name %s not unique',
      $name,
    );

    $type = TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor(
      $shape_field_name_resolver ?? ($_, $_)[] ==> null,
    ));

    $this->methods[$name] = shape(
      'body' => StaticTypeAssertionCodegen\emit_body_for_assertion_function(
        StaticTypeAssertionCodegen\from_type<T>(
          $table,
          panic<>,
          $shape_field_name_resolver,
        ),
      ),
      'type' => $type,
    );
  }

  public function __dispose(): void {
    $code = Str\format(
      <<<'HACK'
/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

final class %s {
%s
}

HACK
      ,
      $this->codegenTargetClass,
      Vec\map_with_key(
        $this->methods,
        ($name, $its) ==> Str\format(
          '  public static function %s(mixed $htl_untyped_variable): %s { %s }',
          $name,
          $its['type'],
          $its['body'],
        ),
      )
        |> Str\join($$, "\n"),
    );

    \touch($this->file);
    hackfmt($this->file, $code);
    ($this->storeMethods)($this->methods);
  }
}
