using SimpleMatch
using Test

@test isempty(detect_ambiguities(SimpleMatch))

a = 1
b = "2.0"
matched = @match(a, b) do
  (::Int, ::AbstractFloat) -> b + 3
  function (args...) 
    args[1] + 9
  end
end
@test matched == 10



a = 1
b = 2.0
matched = @match(a, b) do f
  f(::Int, ::AbstractFloat) = b + 3
  function f(args...)
    args[1] + 9
  end
end
@test matched == 5.0
