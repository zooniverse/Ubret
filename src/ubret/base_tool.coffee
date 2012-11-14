class BaseTool

  required_opts: ['data', 'selector', 'el', 'keys']

  constructor: (opts) ->

    for opt in @required_opts
      throw "missing option #{opt}" unless _.has opts, opt

    @data = crossfilter(opts.data)
    @count = opts.data.length
    @selector = opts.selector
    @keys = opts.keys
    @el = opts.el

    @selectedElements = opts.selectedElements or []
    @selectElementsCb = opts.selectElementsCb or ->

    @selectedKey = opts.selectedKey or 'id'
    @selectKeyCb = opts.selectKeyCb or ->

    @createDimensions()

    @addFilters opts.filters
    @initialized = true

  getTemplate: =>
    @template

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

  addFilters: (filters) =>
    @dimensions[filter.key].filterRange([filter.min, filter.max]) for filter in filters
    @start() if @initialized

  receiveSetting: (key, value) =>
    @[key] = value
    @start()

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()
      
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = BaseTool
else
  window.Ubret['BaseTool'] = BaseTool