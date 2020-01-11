using SimpleMatch
using Test

a = 1
b = 2.0
matched = @match(a, b) do f
  f(::Int, ::AbstractFloat) = b + 3
  f(_...) = a + 9
end
@test matched = 5.0
