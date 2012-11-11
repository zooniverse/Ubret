class BaseTool

  required_opts: ['data', 'selector', 'el', 'keys']

  constructor: (opts) ->
    
    for opt in @required_opts
      throw "missing option #{opt}" unless _.has opts, opt
    
    @data = crossfilter(opts.data)
    @selector = opts.selector
    @keys = opts.keys
    @el = opts.el
    
    @selectElementCb = opts.selectElementCb or ->
    @selectKeyCb = opts.selectKeyCb or ->

    @selectedElement = opts.selectedElement or null
    @selectedKey = opts.selectedKey or 'id'

    console.log @keys
    @createDimensions()

  getTemplate: =>
    @template

  prettyKey: (key) =>
    @capitalizeWords(@underscoresToSpaces(key))

  uglifyKey: (key) =>
    @spacesToUnderscores(@lowercaseWords(key))

  selectElements: (ids) =>
    @selectedElements = ids
    @selectElementsCb ids
    @start()

  selectKey: (key) =>
    @selectedKey = key
    @selectKeyCb key
    @start()

  createDimensions: =>
    @dimensions = new Object
    for key in @keys
      @dimensions.id = @data.dimension( (d) -> d.id )
      @dimensions[key] = @data.dimension( (d) -> d[key] )

  addFilters: ->

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()
      
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = BaseTool
else
  window.Ubret['BaseTool'] = BaseTool