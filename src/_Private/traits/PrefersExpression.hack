/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\_Private;

trait PrefersExpression {
  require implements TypeDescription;

  final public function emitAssertionStatement(
    string $_sub_expression,
  )[]: string {
    return '';
  }
}
