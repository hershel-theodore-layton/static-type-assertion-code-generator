/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

/**
 * @param $type_alias_asserters
 * The value of this dict is a fqn of a function or static method,
 * but unlike a strict fqn, the leading slash may be dropped.
 * These functions must have the following signature:
 * `(function(mixed): X)` where `X` is the `typename<mixed>` from the key.
 * This type is not enforced and only used for documentation purposes.
 *
 * See /README.md for how it is used in the codegen logic.
 */
type TTypeAliasAsserters = dict<typename<mixed>, string>;
