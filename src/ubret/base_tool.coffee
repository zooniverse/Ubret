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
    @selectTool()

  selectTool: =>
    @tool_view = $("#{@selector}")

  extractKeys: =>
    @keys = []
    for key, value of @data[0]
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey in undesiredKeys

  prettyKey: (key) =>
    @capitalizeWords(@underscoresToSpaces(key))

  uglifyKey: (key) =>
    @spacesToUnderscores(@lowercaseWords(key))


  # Helpers
  underscoresToSpaces: (string) ->
    string.replace /_/g, " "

  capitalizeWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  spacesToUnderscores: (string) ->
    string.replace /\s/g, "_"

  lowercaseWords: (string) ->
    string.replace /(\b[A-Z])/g, (char) ->
      char.toLowerCase()


module.exports = BaseTool