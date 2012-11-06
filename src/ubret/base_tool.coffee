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

    unless _.has opts, 'keys'
      throw 'must provide keys'
    else
      @keys = opts.keys

    @selectElementCb = opts.selectElementCb || ->
    @selectKeyCb = opts.selectKeyCb || ->

    @selectedElement = opts.selectedElement || null
    @selectedKey = opts.selectedKey || 'id'

  getTemplate: =>
    @template
    
  prettyKey: (key) =>
    @capitalizeWords(@underscoresToSpaces(key))

  uglifyKey: (key) =>
    @spacesToUnderscores(@lowercaseWords(key))

  selectElement: (id) =>
    @selectedElement = id
    @selectElementCb id
    @start()

  selectKey: (key) =>
    @selectedKey = key
    @selectKeyCb key
    @start()

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

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = BaseTool
else
  window.Ubret['BaseTool'] = BaseTool