/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Tests;

function panic(string $message)[]: nothing {
  throw new InvariantException($message);
}
