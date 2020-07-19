module SimpleMatch
export @match
using Compat

"""
  matches arguments against locally created function and returns match

Simple match implementation which uses a locally created function.
  This gives a very familiar syntax and is natural to use.

Example
```
a = 1
b = 2.0
matched = @match(a, b) do f
  f(::Int, ::AbstractFloat) = b + 3
  f(_...) = a + 9
end
# 5.0
```

We need to define this as macro, as it turns out to be relatively difficult
  to define a function within an anonymous do notation
"""
macro match(define_func!, args...)
  @assert define_func!.head == :(->)  "expecting anonymous function as first argument"
  @assert define_func!.args[1].head == :tuple  "expecting anonymous function as first argument"
  @assert length(define_func!.args[1].args) == 1  "expecting define_func! to take exactly 1 argument, found $(length(define_func!.args[1].args))"

  function_name = define_func!.args[1].args[1]  # single argument of function
  function_definition = define_func!.args[2]  # function body

  esc(quote
    let
      function $function_name end
      $function_definition
      $function_name($(args...))
    end
  end)
end

end # module
