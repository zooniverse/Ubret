class BaseTool

  required_init_opts: ['selector', 'el']
  required_render_opts: ['selector', 'el', 'data', 'keys']

  constructor: ({@selector, @el}) ->
    
  setOpts: (opts) =>
    for key, value of opts
      switch key 
        when 'data'
          @data = crossfilter(value)
          @count = value.length
        when 'filters'
          @addFilters value
        else
          @[key] = value

    @dimensions = new Object
    @createDimensions('uid')
    @createDimensions(@selectedKey) if typeof @selectedKey isnt 'undefined'
    @checkOpts @required_init_opts

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
    dimKeys = []
    unless _.isArray keys
      dimKeys.push keys
    else
      dimKeys = keys
    @dimensions[key] = @data.dimension((d) -> d[key]) for key in dimKeys

  addFilters: (filters) =>
    # @dimensions[filter.key].filterRange([filter.min, filter.max]) for filter in filters
    # @start() if @initialized # temp

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