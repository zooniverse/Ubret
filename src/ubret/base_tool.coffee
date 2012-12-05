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
          original_data = _.map opts.data, (datum) ->
            # Add a unique ID to each record
            _.extend {uid: _.uniqueId()}, datum
          @data = crossfilter(original_data)
          @count = opts.data.length
        when 'filters'
          @addFilters opts.filters
        else
          @[opt] = opts[opt]

    @dimensions = new Object
    if @data and @keys
      @createDimensions('uid')
      @createDimensions(@selectedKey) if typeof @selectedKey isnt 'undefined'
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
    delete @dimensions[@selectedKey]
    @createDimensions key
    @selectedKey = key
    @selectKeyCb key
    @start()

  createDimensions: (keys) =>
    dim_keys = []
    unless _.isArray keys
      dim_keys.push keys
    else
      dim_keys = keys
    @dimensions[key] = @data.dimension((d) -> d[key]) for key in dim_keys
    

  addFilters: (filters) =>
    # @dimensions[filter.key].filterRange([filter.min, filter.max]) for filter in filters
    # @start() if @initialized # temp

  receiveSetting: (key, value) =>
    console.log key, value
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