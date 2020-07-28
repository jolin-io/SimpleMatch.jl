SimpleMatch
===========
[![Build Status](https://github.com/schlichtanders/SimpleMatch.jl/workflows/CI/badge.svg)](https://github.com/schlichtanders/SimpleMatch.jl/actions)
[![Coverage](https://codecov.io/gh/schlichtanders/SimpleMatch.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/schlichtanders/SimpleMatch.jl)

Install with
```julia
using Pkg
pkg"registry add https://github.com/JuliaRegistries/General"  # central julia registry
pkg"registry add https://github.com/schlichtanders/SchlichtandersJuliaRegistry.jl"  # custom registry
pkg"add SimpleMatch"
```
and load it
```
using SimpleMatch
```
which gives you access to the one and only macro of this package ``@match``.

Usage
-----

With match you can define local dispatch, i.e. you can rewrite
```julia
myhelperfunctionname(a::Int) = a + 2
myhelperfunctionname(a::String) = a * "!"
myhelperfunctionname("hi")  # "hi!""
```
as
```julia
@match("hi") do f
  f(a::Int) = a + 2
  f(a::String) = a * "!"
end
# "hi!""
```

You get full standard dispatch but don't have to care any longer about how to name your intermediate function.
Just name it `f` always. The ``do-syntax`` guarantees that this is a local function which cannot interfere at all.

Of course you can also dispatch on values using standard ``Val``. E.g. very useful when working with ``Base.Expr``
```julia
expr = :(function dummy end)
a = expr.head
@match(Val(a)) do f
  f(::Val{:function}) = "a function definition"
  f(::Val{:(=)}) = "maybe another function definition"
end
```

You may also like
-----------------

As the name suggests, this is a super minimal version of inline matching. I think it especially useful because of its
simplicity. It won't give you any heavy dependency (excluding documentation the ``@match`` macro is only 15 lines long).

On the other hand, if you want something more flexible, more powerful, check out https://github.com/kmsquire/Match.jl.
