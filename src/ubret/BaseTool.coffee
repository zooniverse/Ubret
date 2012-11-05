
class BaseTool

  required_opts: ['data']

  constructor: (opts) ->
    unless _.has opts, 'data'
      throw 'must provide data'
    else
      @data = opts.data

    unless _.has opts, 'selector'
      throw 'must provide selector'
    else
      @selector = opts.selector

    @extractKeys()

  selectTool: =>
    @tool_view = $("#{@selector}")

  extractKeys: =>
    @keys = []

    for key, value of @data[0]
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey in undesiredKeys

  prettyKey: (key) =>
    @capitalizeWords(@underscoresToSpaces(key))

  # Helpers
  underscoresToSpaces: (string) ->
    string.replace /_/g, " "

  capitalizeWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()




module.exports = BaseTool