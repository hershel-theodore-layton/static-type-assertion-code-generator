# static-type-assertion-code-generator

Codegen functions equivalent to type testing `as` expressions.

## Why static-type-assertion-code-generator?

This library was written with three things in mind, in order of importance:
 - Be sound at all costs, prove to Hack that you're doing the sound thing.
 - Be as fast as possible by doing as little work as possible.
 - Assume the runtime type is correct, optimize for the happy path.

Every piece of data that arrives in Hack from the outside world, that being apc, databases, json, POST data, or what have you, is all untyped. In a sound Hack program, you'll need to turn this data into typed data, before doing anything useful with it. Doing this validation by hand is tedious work which can be easily automated. The code that is generated for you is the quickest pure Hack way I know of to get this untyped data typed.

The code that is generated does not rely on any library functions. You are therefore recommended to install this library as a development dependency. You should exclude the files which invoke the code generator from your production build. This way Hack does not issue errors when the library code falls away in a production build.

The current version of static-type-assertion-code-generator only supports validating these types:
 
 - arraykey
 - (a, b)
 - bool
 - dict<_, _>
 - float
 - int
 - keyset<_>
 - mixed
 - nonnull
 - null
 - num
 - shape(...)
 - string
 - vec<_>

Support for other types can be added using aliases and TTypeAliasAsserters.

If this static-type-assertion-code-generator does not do everything you need it to do, I recommend looking towards TypeAssert.

This library is heavily inspired by [TypeAssert](https://github.com/hhvm/type-assert). TypeAssert has made different design decisions and was written for an overlapping but different purpose. TypeAssert inspects a reified generic at runtime and composes objects to approximate a fully sound assertion for the type you gave it. TypeAssert supports almost every type in Hack, but some of its assertions are not sound. Performance does matter in the minds of the TypeAssert developers, but ease of use and friendly error messages are more important to them. TypeAssert is generally a good first choice, since it gives amazingly helpful error messages when the runtime type and the expected types do not match, which will help you greatly when debugging.

## TTypeAliasAsserters

By default static-type-assertion-code-generator will recurse all the way down to primitives and generate all the code in one function. This gets bloaty pretty fast, especially for large shape types. You can reduce the size of the code you generate by pointing static-type-assertion-code-generator to functions which will validate a particular type alias. I used this technique in [the benchmark](./benchmark/2-codegen.hack) to deduplicate the `"entities"` and `"user"` keys which both appeared twice in the json and have the exact same structure in both places.

Keeping your code small reduces the amount of things the JIT needs to optimize individually. The JIT reserves a certain amount of space for hot code. If you run large amounts of data through these functions often, the JIT will put it in the hot portion. Keeping the code small allows more functions to fit in the hot section.

## Newtype

Hack has both `type` and `newtype` aliases. An alias created with the `type` keyword is equivalent to the right hand side. So for `type A = int` you can pass an `A` where an `int` is expected and an `int` where an `A` is expected. An alias created with the `newtype` keyword is (partially) opaque. So for `newtype UserID = int` you can not simply codegen `$x as int` and be done with it. We need you to supply the function that does this upcast for us. You probably already have a function that upcasts something to a `UserID`. You can pass this function name to static-type-assertion-code-generator and it will codegen a call to this function with a `mixed` value. It is up to you to do the validation for both the type\* and the application specific invariants of `UserID`. If you do not provide a function for `UserID`, the codegen will fail, since it can't know what your upcast function is called.

\*_Sidenote, you can create two copies of your `newtype`. `newtype TActualType = TRawType; type TRawType = <complex>`. You can then use the `TRawType` codegen in your upcast to `TActualType` function to save some effort._

## Why must I provide an asserter for an enum?

Hack and hhvm can not agree about how `as` works on an `enum`. When `is` and `as` were introduced in [hhvm version 3.28.0](https://hhvm.com/blog/2018/08/28/hhvm-3.28.0.html), the team noted that `is` and `as` will perform integral key conversion to main compatibility with `BuildInEnum::isValid()`. Given the enum `enum ThereCanBeOnly: int { ONE = 1; }` the `as` expression `'1' as ThereCanBeOnly` yields `string(1) "1"`. This is not sound, since a function that takes a `ThereCanBeOnly` will throw a `TypeError` when supplied with a string `"1"`. I hope that the hhvm team can deprecate and remove this behavior, since it is really confusing. Once this behavior is removed, I will update this library. A default `as` check will be codegenned, provided your hhvm version meets the minimum version requirement for the sensible `as` check.

Until then, you must provide your own assertion function for enums. You have the knowledge whether `$x as YourEnum` is a safe implementation (integral key coercion can't happen for `YourEnum`). If does contain those values, you can validate using `C\contains_key(YourEnum::getNames(), $x)`, but only if your enum does not have duplicate values. If it does have duplicate values, you can use `C\contains(YourEnum::getValues(), $x)`. You may also decide you want to use `YourEnum::assert()`, which does actually change ints into strings and vice versa. Because of these many degrees of freedom, the default implementation is to stop the codegen.
