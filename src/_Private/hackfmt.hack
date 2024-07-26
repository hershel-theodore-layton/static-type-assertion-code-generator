/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

function hackfmt(string $path, string $code)[defaults]: void {
  \file_put_contents($path, $code);
  \shell_exec('hackfmt -i '.\escapeshellarg($path));
}
