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

  do_args = define_func!.args[1].args  # @match do args
  do_body = define_func!.args[2]  # @match do body
  
  if length(do_args) == 0
    @gensym name

    # name anonymous functions
    for expr in do_body.args
      if isa(expr, Expr) && expr.head ∈ (:function, :->, :(=))
        @assert expr.args[1].head ∈ (:tuple, :...) "expecting anonymous functions within body of @match, found function named '$(expr.args[1].args[1])'"
        # make it to a named function
        expr.head = :function
        func_args = expr.args[1].head == :... ? [expr.args[1]] : expr.args[1].args
        expr.args[1] = Expr(:call, name, func_args...)
      end
    end

  elseif length(do_args) == 1
    name = do_args[1]

  else
    throw(AssertionError("expecting do-block to take 0 or 1 argument, found $(length(define_func!.args[1].args))"))
  end

  esc(quote
    let
      function $name end
      $do_body
      $name($(args...))
    end
  end)
end

end # module
