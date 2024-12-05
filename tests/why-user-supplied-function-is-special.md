## Why UserSuppliedFunction is special

When constructing a TypeDescription for `?int`,
the `NullableTypeDescription` handles the `null` case
and the `IntTypeDescription` handles the `int` case.
The inner TypeDescription (Int) does not need to know
that the type as a whole is nullable.

Given `newtype Newed = int;`, the TypeDescription for
`?Newed` wraps a `NullableTypeDescription` around
the `cast_to_newed(mixed $mixed)[]: Newed` function.
The user function would fail when invoked with `null`,
even though `null` is a valid value of the `?Newed` type.
`cast_to_newed(mixed $mixed)[]: Newed` can not do something
sensible if (and only if) the type was nullable, since
this bit of information is never provided to it.

Given `newtype Nullish = ?int;`, the user defined function
`cast_to_nullish(mixed $mixed)[]: Nullish` will expect to
handle nulls. If a `NullableTypeDescription` was wrapped
around the user supplied function, `null` would never be
passed to it. If `cast_to_nullish(mixed $mixed)[]: Nullish`
started with the line `if ($mixed is null) return 42;`,
the author would be surpriced if we codegen if-null-use-null.

So in order to act in the way the user expects, we must
have a heuristic "can this function handle nulls". The
assumption will be:

 - Given `Newer` pass the value. Null is not special here.
 - Given `?Newer`, handle `null` before calling the function.
 - Given `Nullish`, pass the value. Null is a valid value for `Nullish`.
 - Given `?Nullish`, treat as `Nullish`.
