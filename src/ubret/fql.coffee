Fql = {}

class Fql.Expression

class Fql.Value
  eval: => 
    @

class Fql.Number extends Fql.Value
  constructor: (@num) ->

  add: (value) =>
    value.addNumber @

  addNumber: ({num}) =>
    new Fql.Number(@num + num)

  addField: ({name}) =>
    new Fql.CFunc((i) => i[name] + @num)

  addCFunc: (value) =>
    value.addNumber @

  negate: =>
    -(@num)

  reciprocate: =>
    1/@num

  multiply: (value) =>
    value.multiplyNumber @

  multiplyNumber: ({num}) =>
    new Fql.Number(@num * num)

  multiplyCFunc: (value) =>
    value.multiplyNumber @

  multiplyField: ({name}) =>
    new Fql.CFunc((i) => @num * i[name])

  equalTo: (value) =>
    value.equalToNumber @

  equalToNumber: ({num}) =>
    new Fql.CFunc((i) => num is @num)

  equalToCFunc: ({func}) =>
    new Fql.CFunc((i) => @num is func(i))

  equalToField: ({name}) =>
    new Fql.CFunc((i) => @num is i[name])

  greaterThan: (value) =>
    value.greaterThanNumber @

  greaterThanNumber: ({num}) =>
    new Fql.CFunc((i) => num > @num)

  greaterThanCFunc: ({func}) =>
    new Fql.CFunc((i) => func(i) > @num)

  greaterThanField: ({name}) =>
    new Fql.CFunc((i) => i[name] > @num)

  log: ({num}) =>
    Math.log(@num) / if num then Math.log(num) else 1

  pow: ({num}) => 
    Math.pow(@num, num)

class Fql.CFunc extends Fql.Value
  constructor: (@func) ->

  add: (value) =>
    value.addCFunc @

  addNumber: ({num}) =>
    new Fql.CFunc((i) => @func(i) + num)

  addField: ({name}) =>
    new Fql.CFunc((i) => @func(i) + i[name])

  addCFunc: ({func}) =>
    new Fql.CFunc((i) => @func(i) + func(i))

  negate: =>
    new Fql.CFunc((i) => -(@func(i)))

  reciprocate: =>
    new Fql.CFunc((i) => 1/@func(i))

  equalTo: (value) =>
    value.equalToCFunc @

  equalToNumber: (value) =>
    value.equalToCFunc @

  equalToCFunc: ({func}) =>
    new Fql.CFunc((i) => @func(i) is func(i))

  equalToField: ({field}) =>
    new Fql.CFunc((i) => @func(i) is i[field])

  greaterThan: (value) =>
    value.greaterThanCFunc @

  greaterThanNumber: ({num}) =>
    new Fql.CFunc((i) => num > @func(i))

  greaterThanCFunc: ({func}) =>
    new Fql.CFunc((i) => func(i) > @func(i))

  greaterThanField: ({field}) =>
    new Fql.CFunc((i) => i[field] > @func(i))

  multiply: (value) =>
    value.multiplyCFunc @

  multiplyNumber: ({num}) =>
    new Fql.CFunc((i) => @func(i) * num)

  multiplyCFunc: ({func}) =>
    new Fql.CFunc((i) => @func(i) * func(i))

  multiplyField: ({name}) =>
    new Fql.CFunc((i) => @func(i) * i[name])

  log: ({num}) =>
    new Fql.CFunc((i) => Math.log(@func(i)) / (if num then Math.log(num) else 1))

  pow: ({num}) =>
    new Fql.CFunc((i) => Math.pow(@func(i), num))

class Fql.Field extends Fql.Value
  constructor: (@name) ->

  add: (value) =>
    value.addField @

  addNumber: (value) =>
    value.addField @

  addField: ({name}) =>
    new Fql.CFunc((i) => i[@name] + i[name])

  addCFunc: (value) =>
    value.addField @

  equalTo: (value) =>
    value.equalToField @

  equalToNumber: (value) =>
    value.equalToField @

  equalToCFunc: (value) =>
    value.equalToField @

  equalToField: ({field}) =>
    new Fql.CFunc((i) => i[field] is i[@field])

  greaterThan: (value) =>
    value.greaterThanField @

  greaterThanNumber: ({num}) =>
    new Fql.CFunc((i) => num > i[@field])

  greaterThanCFunc: ({func}) =>
    new Fql.CFunc((i) => func(i) > i[@field])

  greaterThanField: ({field}) =>
    new Fql.CFunc((i) => i[field] > i[@field])

  multiply: (value) =>
    value.multiplyField @

  multiplyNumber: (value) =>
    value.multiplyField @

  multiplyField: ({name}) =>
    new Fql.CFunc((i) => i[@name] * i[name])

  mutliplyCFunc: (value) =>
    value.multiplyField @

  negate: =>
    new Fql.CFunc((i) => -(i[@name]))

  reciprocate: =>
    new Fql.CFunc((i) => 1/(i[@name]))

  log: ({num}) =>
    new Fql.CFunc((i) => Math.log(i[@name]) / if num then Math.log(num) else 1)

  pow: ({num}) =>
    new Fql.CFunc((i) => Math.pow(i[@name], num))

class Fql.Select extends Fql.Expression
  constructor: (@funcExp) ->

  eval: =>
    {func: @funcExp.eval().func}

class Fql.Filter extends Fql.Expression
  constructor: (@funcExp) ->

  eval: =>
    {func: @funcExp.eval().func}

class Fql.NewField extends Fql.Expression
  constructor: (@fieldName, @funcExp) ->

  eval: =>
    {field: @fieldName, func: @funcExp.eval()}

class Fql.Add extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().add @exp2.eval()

class Fql.Subtract extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().add new Negate(@exp2).eval()

class Fql.Negate extends Fql.Expression
  constructor: (@exp) ->

  eval: =>
    @exp.eval().negate()

class Fql.Multiply extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().multiply @exp2.eval()

class Fql.Reciprocate extends Fql.Expression
  constructor: (@exp) ->

  eval: =>
    @exp.eval().reciprocate()

class Fql.Divide extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().muliply new Reciprocate(@exp2).eval()

class Fql.Log extends Fql.Expression
  constructor: (@exp, @base) ->

  eval: =>
    if @base instanceof Fql.Number
      @exp.eval().log @base
    else
      throw new Error "Base must be a FQL Number"

class Fql.Pow extends Fql.Expression
  constructor: (@exp, @pow) ->

  eval: =>
    if @pow instanceof Fql.Number
      @exp.eval().pow @pow
    else
      throw new Error "Pow must be an FQL Number"

class Fql.Equality extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().equalTo @exp2.eval()

class Fql.Not extends Fql.Expression
  constructor: (@exp) ->
  
  eval: =>
    new Fql.CFunc( (i) => not @exp.eval().func(i))

class Fql.NotEquality extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    new Fql.Not(new Fql.Equality(@exp1, @exp2)).eval()

class Fql.GreaterThan extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    @exp1.eval().greaterThan @exp2.eval()

class Fql.Or extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: =>
    new Fql.CFunc( (i) => @exp1.eval().func(i) or @exp2.eval().func(i))

class Fql.GreaterThanOrEqual
  constructor: (@exp1, @exp2) ->

  eval: =>
    new Fql.Or(new Fql.GreaterThan(@exp1, @exp2), new Fql.Equality(@exp1, @exp2)).eval()

class Fql.LessThan
  constructor: (@exp1, @exp2) ->

  eval: =>
    new Fql.GreaterThan(@exp2, @exp1).eval()

class Fql.LessThanOrEqual
  construcotr: (@exp1, @exp2) ->

  eval: =>
    new Fql.GreaterThanOrEqual(@exp2, @exp1).eval()

window.Ubret.Fql = Fql
