include("./ParserCombinator.jl")
using ParserCombinator

function E()
  @rule(
    A()
  )
end

function A()
  @rule(
    p_chainl(
       M(),
       (p_string("+") > (op) -> (lhs, rhs) -> lhs + rhs) /
       (p_string("-") > (op) -> (lhs, rhs) -> lhs - rhs)
    )
   )
end

function M()
  @rule(
    p_chainl(
      P(),
      (p_string("*") > (op) -> (lhs, rhs) -> lhs * rhs) /
      (p_string("/") > (op) -> (lhs, rhs) -> lhs / rhs)
    )
  )
end

function P() 
  @rule(
    (
      (p_string("(") + E() + p_string(")")) >
      function(values)
        return values[1][2]
      end
    ) /
    N()
  )
end

function N()
  @rule(
    p_regex(r"[0-9]+") > (n) -> parse(Int64, n)
  )
end

const parser = E()
println(parser.parse("(1+2)*(3+4)"))
