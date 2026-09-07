/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use namespace HH\Lib\{C, Str, Vec};
use namespace HTL\{StaticTypeAssertionCodegen, TypeVisitor};
use type IDisposable;
use function HTL\StaticTypeAssertionCodegen\_Private\hackfmt;
use function escapeshellarg, exec, touch;

/**
 * Note to self, this file is not formatted by hackfmt,
 * hackfmt sees at-sign-generated and leaves this file alone.
 */
final class CodegenHelper implements IDisposable {
  const string CODEGEN_BASE = __DIR__.'/../codegen/';
  const type TMethods =
    dict<string, shape('body' => string, 'type' => string /*_*/)>;

  private this::TMethods $methods = dict[];
  private string $file;

  public function __construct(
    private string $codegenTargetClass,
    private (function(this::TMethods)[defaults]: void) $storeMethods,
  )[] {
    $this->file = static::CODEGEN_BASE.$codegenTargetClass.'.generated.hack';
  }

  public function createMethod<reify T>(
    string $name,
    dict<string, string> $table = dict[],
    ?(function(?string, arraykey)[]: ?string) $shape_field_name_resolver = null,
  )[write_props]: void {
    invariant(
      !C\contains_key($this->methods, $name),
      'Method name %s not unique',
      $name,
    );

    $options = shape('closed_shape_suffix' => '/*_*/');

    $type = TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor(
      $shape_field_name_resolver ?? ($_, $_)[] ==> null,
      $options,
    ));

    $this->methods[$name] = shape(
      'body' => StaticTypeAssertionCodegen\emit_body_for_assertion_function(
        StaticTypeAssertionCodegen\from_type<T>(
          $table,
          panic<>,
          $shape_field_name_resolver,
          $options,
        ),
      ),
      'type' => $type,
    );
  }

  public function __dispose()[defaults]: void {
    // hackfmt-ignore
    $code = Str\format(<<<'HACK'
/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during testing, run `vendor/bin/hacktest tests` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:'])>>

final class %s {
%s
}

HACK
      ,
      $this->codegenTargetClass,
      Vec\map_with_key(
        $this->methods,
        ($name, $its) ==> Str\format(
          '  public static function %s(mixed $htl_untyped_variable)[]: %s { %s }',
          $name,
          $its['type'],
          $its['body'],
        ),
      )
        |> Str\join($$, "\n"),
    );

    touch($this->file);
    hackfmt($this->file, $code);
    $output = vec[];
    $status = 0;
    exec(
      escapeshellarg(
        __DIR__.
        '/../../vendor/hershel-theodore-layton/portable-hack-ast-linters-server/bin/pha-sign-hack-source.sh',
      ).
      ' '.
      escapeshellarg($this->file),
      inout $output,
      inout $status,
    );
    invariant($status === 0, 'Could not sign generated fixture');
    ($this->storeMethods)($this->methods);
  }
}
