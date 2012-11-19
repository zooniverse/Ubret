class BaseTool

  required_init_opts: ['selector', 'el']
  required_render_opts: ['selector', 'el', 'data', 'keys']

  constructor: (opts) ->
    @setOpts opts
    @checkOpts @required_init_opts

  setOpts: (opts) =>
    for opt of opts
      switch opt
        when 'data'
          @data = crossfilter(opts.data)
          @count = opts.data.length
        when 'filters'
          @addFilters opts.filters
        else
          @[opt] = opts[opt]

    if @data and @keys
      @createDimensions()
      @initialized = true

  getTemplate: =>
    @template

  start: =>
    @el.html ''
    @checkOpts @required_render_opts

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

  checkOpts: (required_opts = @required_data_opts) =>
    for opt in required_opts
      throw "missing option #{opt}" unless _.has @, opt
      

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = BaseTool
else
  window.Ubret['BaseTool'] = BaseTool