include("./ParserCombinator.jl")
using ParserCombinator

function E()
  p_rule() do
    A()
  end
end

function A()
  p_rule() do
    p_chainl(
       M(),
       (p_string("+") > (op) -> (lhs, rhs) -> lhs + rhs) /
       (p_string("-") > (op) -> (lhs, rhs) -> lhs - rhs)
    )
  end
end

function M()
  p_rule() do
    p_chainl(
             P(),
             (p_string("*") > (op) -> (lhs, rhs) -> lhs * rhs) /
             (p_string("/") > (op) -> (lhs, rhs) -> lhs / rhs)
            )
  end
end

function P() 
  p_rule() do
    p_map(
          p_string("(") + E() + p_string(")"),
          function(values)
            return values[1][2]
          end
         ) / N()
  end
end

function N()
  p_rule() do
    p_regex(r"[0-9]+") > (n) -> parse(Int64, n)
  end
end

const parser = E()
println(parser.parse("(1+2)*(3+4)"))
