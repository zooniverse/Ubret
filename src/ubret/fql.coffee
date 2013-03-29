Fql = {}

class Fql.Expression

class Fql.Value
  eval: -> 
    @

class Fql.Number extends Fql.Value
  constructor: (@num) ->

  add: (value) ->
    value.addNumber @

  addNumber: ({num}) ->
    @num + num

  addField: ({name}) ->
    new Fql.CFunc((i) => i[name] + @num)

  addCFunc: (value) ->
    value.addNumber @

  negate: ->
    -(@num)

  reciprocate: ->
    1/@num

  multiply: (value) ->
    value.multiplyNumber @

  multiplyNumber: ({num}) ->
    @num * num

  multiplyCFunc: (value) ->
    value.multiplyNumber @

  multiplyField: ({name}) ->
    new Fql.CFunc((i) => @num * i[name])

  log: ({num}) ->
    Math.log(@num) / if num then Math.log(num) else 1

  pow: ({num}) -> 
    Math.pow(@num, num)

class Fql.CFunc extends Fql.Value
  constructor: (@func) ->

  add: (value) ->
    value.addCFunc @

  addNumber: ({num}) ->
    new Fql.CFunc((i) => @func(i) + num)

  addField: ({name}) ->
    new Fql.CFunc((i) => @func(i) + i[name])

  addCFunc: ({func}) ->
    new Fql.CFunc((i) => @func(i) + func(i))

  negate: ->
    new Fql.CFunc((i) => -(@func(i)))

  reciprocate: ->
    new Fql.CFunc((i) => 1/@func(i))

  multiply: (value) ->
    value.multiplyCFunc @

  multiplyNumber: ({num}) ->
    new Fql.CFunc((i) => @func(i) * num)

  multiplyCFunc: ({func}) ->
    new Fql.CFunc((i) => @func(i) * func(i))

  multiplyField: ({name}) ->
    new Fql.CFunc((i) => @func(i) * i[name])

  log: ({num}) ->
    new Fql.CFunc((i) => Math.log(@func(i)) / (if num then Math.log(num) else 1))

  pow: ({num}) ->
    new Fql.CFunc((i) => Math.pow(@func(i), num))

class Fql.Field extends Fql.Value
  constructor: (@name) ->

  add: (value) ->
    value.addField @

  addNumber: (value) ->
    value.addField @

  addField: ({name}) ->
    new Fql.CFunc((i) => i[@name] + i[name])

  addCFunc: (value) ->
    value.addField @

  multiply: (value) ->
    value.multiplyField @

  multiplyNumber: (value) ->
    value.multiplyField @

  multiplyField: ({name}) ->
    new Fql.CFunc((i) => i[@name] * i[name])

  mutliplyCFunc: (value) ->
    value.multiplyField @

  negate: ->
    new Fql.CFunc((i) => -(i[@name]))

  reciprocate: ->
    new Fql.CFunc((i) => 1/(i[@name]))

  log: ({num}) ->
    new Fql.CFunc((i) => Math.log(i[@name]) / if num then Math.log(num) else 1)

  pow: ({num}) ->
    new Fql.CFunc((i) => Math.pow(i[@name], num))

class Fql.Select extends Fql.Expression
  constructor: (@funcExp) ->

  eval: ->

class Fql.Filter extends Fql.Expression
  constructor: (@funcExp) ->

class Fql.NewField extends Fql.Expression
  constructor: (@fieldName, @funcExp) ->

  eval: ->
    {field: @fieldName, func: @funcExp.eval()}

class Fql.Add extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: ->
    @exp1.eval().add @exp2.eval()

class Fql.Subtract extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: ->
    @exp1.eval().add new Negate(@exp2).eval()

class Fql.Negate extends Fql.Expression
  constructor: (@exp) ->

  eval: ->
    @exp.eval().negate()

class Fql.Multiply extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: ->
    @exp1.eval().multiply @exp2.eval()

class Fql.Reciprocate extends Fql.Expression
  constructor: (@exp) ->

  eval: ->
    @exp.eval().reciprocate()

class Fql.Divide extends Fql.Expression
  constructor: (@exp1, @exp2) ->

  eval: ->
    @exp1.eval().muliply new Reciprocate(@exp2).eval()

class Fql.Log extends Fql.Expression
  constructor: (@exp, @base) ->

  eval: ->
    if @base instanceof Fql.Number
      @exp.eval().log @base
    else
      throw new Error "Base must be a FQL Number"

class Fql.Pow extends Fql.Expression
  constructor: (@exp, @pow) ->

  eval: ->
    if @pow instanceof Fql.Number
      @exp.eval().pow @pow
    else
      throw new Error "Pow must be an FQL Number"

window.Ubret.Fql = Fql
