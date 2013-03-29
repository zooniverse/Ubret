start = statement+

statement
  = newField 

newField
  = "New Field" _ name:[A-z0-9 ]+ "," _ exp:expression LineEnd { return new Fql.NewField(name.join(""), exp); }

expression
  = rightOperator
  / leftOperator
  / unary

rightOperator = additive / subtractive

additive
  = left:leftOperator _ "+" _ right:rightOperator { return new Fql.Add(left, right) }
  / leftOperator

subtractive
  = left:leftOperator _ "-" _ right:rightOperator { return new Fql.Subtract(left, right) }
  / leftOperator

leftOperator = multiplicative / divisive

multiplicative
  = left:unary _ "*" _ right:leftOperator { return new Fql.Multiply(left, right) }
  / unary

divisive
  = left:unary _ "*" _ right:leftOperator { return new Fql.Divide(left, right) }
  / unary

unary = log / pow / negate / reciprocate

log
  = "log" _ exp:primary "," base:number { return new Fql.Log(exp, base) }
  / primary

pow
  = exp:primary _ "^" _ base:number { return new Fql.Pow(exp, base) }
  / primary

negate
  = "-" exp:primary { return new Fql.Negate(exp) }
  / primary

reciprocate
  = "recip" _ exp:primary { return new Fql.Reciprocal(exp) }
  / primary

primary
  = "(" exp:expression ")" { return exp }
  / value

value = number / field

number 
  = digits:[0-9.]+ { return new Fql.Number(parseFloat(digits.join(""))) }

field
  = "." letters:[A-z0-9_]+ {return new Fql.Field(letters.join("")) }

_ = [ ]?

LineEnd = [\n] / !.