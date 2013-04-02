start = statement+

statement
  = newField 
  / filter

newField
  = "New Field" _ name:[A-z0-9 ]+ "," _ exp:expression _ LineEnd { return new Ubret.Fql.NewField(name.join(""), exp); }

filter
  = "New Filter" _ pred:expression _ LineEnd { return new Ubret.Fql.Filter(pred); }

expression
  = predicate
  / rightOperator
  / leftOperator
  / unary

predicate
  = left:rightOperator _ comp:comparison _ right:predicate { return new comp(left, right); }
  / rightOperator

comparison
  = "=" { return Ubret.Fql.Equality; }
  / "is" { return Ubret.Fql.Equality; }
  / "==" { return Ubret.Fql.Equality; }
  / "!=" { return Ubret.Fql.NotEquality; }
  / ">" { return Ubret.Fql.GreaterThan; }
  / "<" { return Ubret.Fql.LessThan; }
  / ">=" { return Ubret.Fql.GreaterThanOrEqual; }
  / "<=" { return Ubret.Fql.LessThanOrEqual; }

rightOperator = additive / subtractive

additive
  = left:leftOperator _ "+" _ right:rightOperator { return new Ubret.Fql.Add(left, right) }
  / leftOperator

subtractive
  = left:leftOperator _ "-" _ right:rightOperator { return new Ubret.Fql.Subtract(left, right) }
  / leftOperator

leftOperator = multiplicative / divisive

multiplicative
  = left:unary _ "*" _ right:leftOperator { return new Ubret.Fql.Multiply(left, right) }
  / unary

divisive
  = left:unary _ "/" _ right:leftOperator { return new Ubret.Fql.Divide(left, right) }
  / unary

unary = log / pow / negate / reciprocate

log
  = "log" _ exp:primary "," base:number { return new Ubret.Fql.Log(exp, base) }
  / primary

pow
  = exp:primary _ "^" _ base:number { return new Ubret.Fql.Pow(exp, base) }
  / primary

negate
  = "-" exp:primary { return new Ubret.Fql.Negate(exp) }
  / primary

reciprocate
  = "recip" _ exp:primary { return new Ubret.Fql.Reciprocal(exp) }
  / primary

primary
  = "(" exp:expression ")" { return exp }
  / value

value 
  = field
  / number 

number 
  = digits:[0-9.]+ { return new Ubret.Fql.Number(parseFloat(digits.join(""))) }

field
  = "." letters:[A-z0-9_]+ {return new Ubret.Fql.Field(letters.join("")) }

_ = [ ]?

LineEnd = [\n] / !.