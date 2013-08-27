if @.U
  oldU = @.U

@.U = {}

@.U.NoConflict = oldU

@.U._bindContext = (fns, ctx) ->
  return _.map(fns, (fn) -> _.bind(fn, ctx))

@.U.identity = (a) -> a

@.U.dispatch = (dispatchFn, obj, ctx) ->
  _this = ctx or @
  dispatch = _.map(obj, (fns, dispatchVal) ->
    [new RegExp("^" + dispatchVal + "$"), fns])

  (value, args...) -> 
    dispatchVal = dispatchFn.call(_this, value)
    _.chain(dispatch).filter(([key]) -> !_.isEmpty(dispatchVal.match(key)))
      .each(([key, fns]) -> 
        _.each(fns, (fn) -> fn.apply(_this, args.concat(value))))

@.U.pipeline = (fns...) -> 
  _this = @
  (seed, args...) ->
    _.reduce(fns, ((m, fn) -> 
      fn.apply(_this, [m].concat(args))
    ), seed)

@.U.listenTo = (eventEmitter, event, fn, ctx) ->
  eventEmitter.on(event, fn, ctx)

@.U.stopListening = (eventEmitter, event, fn, ctx) -> 
  eventEmitter.off(event, fn, ctx)

class @.U.EventEmitter
  constructor: (@listeners = {}, @ctx = null) ->
    @_listen()

  # Public Methods
  on: (event, fns, ctx=null) ->
    if ctx? and ctx isnt @ctx
      fns = U._bindContext(fns, ctx)

    unless @listeners[event]?
      @listeners[event] = [] 

    @listeners[event] = @listeners[event].concat(fns)
    @_listen()

  off: (event, fn, ctx) ->
    unless event?
      @listeners = {}
    else unless fn?
      @listeners[event] = null
    else 
      if ctx?
        fn = _.bind(fn, ctx)
      @listeners[event] = _.without(@listeners[event], fn)
    @_listen()

  trigger: (args...) ->
    @_listeners.apply(null, args)

  # Private Methods
  _listen: ->
    @_listeners = U.dispatch(U.identity, @listeners, @ctx)

class @.U.State extends U.EventEmitter
  constructor: (@state = {} , @ctx = null, listeners) ->
    super listeners, @ctx

  # Public Methods
  get: (states...) ->
    if _.isEmpty(states)
      return _.clone(@state)
    _.chain(states)
      .map(@_parseStateStrToObj, @)
      .map(([key, deepState]) ->
        if key is "*"
          _.clone(deepState)
        else
          _.clone(deepState[key]))
      .value()

  set: (state, value) ->
    [key, deepState] = @_parseStateStrToObj(state)
    unless _.isEqual(deepState[key], value)
      deepState[key] = value
      @trigger(state, value)

  withState: (state, fn, ctx=null) ->
    if ctx?
      _.bind(fn, ctx)
    return (=> fn(@get(state...)...))

  whenState: (reqState, optState, fn, ctx) ->
    allState = reqState.concat(optState)
    withState = @withState(allState, fn, ctx)
    checkStateAndExecute = () => 
      if _.every(@get(reqState...), ((s) -> s?), @)
        withState()
    _.each(allState, ((state) -> @on(state, checkStateAndExecute)), @)

  # Private Methods
  
  _parseStateStrToObj: (str) ->
    toAccessor = (a) ->
      array = a.match(/\[([0-9]+)\]/);
      return unless _.isNull(array) then parseInt(array[1]) else a

    state = str.split('.')
    finalKey = toAccessor(state.pop())

    stateRef = _.reduce(state, ((m, a, i) ->
      a = toAccessor(a)
      # Check if the key is defined. If not create it
      if (m[a]?)
        nextKey = if (state.length is i + 1) then finalKey else state[i + 1]
        if (_.isNumber(nextKey)) then m[a] = [] else m[a] = {}
      else
        m[a]
    ), @state)
    [finalKey, stateRef]

class @.U.Data
  constructor: (@data, @omittedKeys) ->
    @_invoked = []
    @_perPage = 0
    @_projection = ['*']
    @_sortOrder = 'a'
    @_sortProp = 'uid'
    @keys = _.chain(@data).map((d) ->
      _.keys(_.omit(d, @omittedKeys...)))
      .flatten().uniq().value()


class BaseTool
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb', 'plate', 'mjd', 'fiberID']

  constructor: (options) ->
    _.extend @, U.Events

    @opts = {events: {}, selectedIds: [], data: [], filters: [], fields: []}
    @unitsFormatter = d3.units 'astro'
    @bindEvents @events
    
    if options?.selector
      @selector options.selector
      delete options.selector
    @[key](value) for key, value of options when _.isFunction(@[key])

  toJSON: ->
    json = {}
    json[key] = value for key, value of @opts when key isnt 'selector'
    json

  selector: (selector=null) ->
    @el = document.createElement('div')
    @el.id = selector
    @d3el = d3.select @el
    @trigger 'selector', @d3el
    @

  height: (height=0, triggerEvent=true) ->
    @opts.height = height
    @trigger 'height', @opts.height if triggerEvent
    @

  width: (width=0, triggerEvent=true) ->
    @opts.width = width
    @trigger 'width', @opts.width if triggerEvent
    @

  data: (data=[], triggerEvent=true) =>
    @opts.data = _(data).sortBy (d) -> d.uid
    @keys @_dataKeys(@opts.data[0])
    @trigger 'data', @childData() if triggerEvent and (not _.isEmpty @opts.data)
    @

  keys: (keys=[], triggerEvent = true) =>
    @opts.keys = keys
    @trigger 'keys', @opts.keys if triggerEvent
    @
    
  selectIds: (ids=[], triggerEvent = true) =>
    if _.isArray ids
      @opts.selectedIds = ids
    else if ids in @opts.selectedIds
      @opts.selectedIds = _.without @opts.selectedIds, ids
    else
      @opts.selectedIds.unshift ids unless _.isUndefined ids
    @trigger 'selection', @opts.selectedIds if triggerEvent
    @

  filters: (filters=[], triggerEvent=true, replace=false) =>
    if _.isArray filters
      unless replace
        @opts.filters = @opts.filters.concat filters
      else
        @opts.filters = filters
        @trigger 'data', @childData() 
    else
      @opts.filters.push filters
    if triggerEvent
      @trigger 'add-filters', filters 
      if not _.isEmpty(@opts.data) and ((not _.isEmpty(filters)) or _.isFunction(filters))
        @trigger 'data', @childData() 
    @

  fields: (fields=[], triggerEvent=true, replace=false) =>
    if _.isArray fields 
      unless replace
        @opts.fields = @opts.fields.concat fields 
      else
        @opts.fields = fields
        @trigger 'data', @childData() 
    else
      @opts.fields.push fields
    if triggerEvent
      @trigger 'add-fields', fields
      if not _.isEmpty(@opts.data) and ((not _.isEmpty(fields)) or _.isObject(fields))
        @trigger 'data', @childData() 
    @

  settings: (settings, triggerEvent=true) =>
    for setting, value of settings
      if typeof @[setting] is 'function'
        @[setting](value)
      else
        @opts[setting] = value
      @trigger "setting:#{setting}", value if triggerEvent
    @trigger 'settings', settings if triggerEvent
    @

  parentTool: (tool = null, triggerEvent=true) =>
    # Only bother checking sameness if parentTool is set.
    if @opts.parentTool?
      # Don't re-assign events if parentTool is the same
      if _.isEqual(tool, @opts.parentTool.selector)
        return @
      else
        # Unbind events first if parentTool is different.
        @opts.parentTool.unbind('data', @data)
        @opts.parentTool.unbind('selection', @selection)

    @opts.parentTool = tool

    @data(tool.childData())
      .selectIds(tool.opts.selectedIds)

    @opts.parentTool.on 
      'data': @data 
      'selection': @selectIds

    @trigger 'bound-to', tool if triggerEvent
    @

  removeParentTool: =>
    if @opts.parentTool?
      @opts.parentTool.unbind()
      delete @opts.parentTool
    @

  childData: =>
    @preparedData()

  preparedData: =>
    data = @_addFields(@_filter(@opts.data, @opts.filters), @opts.fields).value()
    @keys @_dataKeys(data[0])
    data

  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  # Private
  _filter: (data, filters) ->
    data = _.chain(data)
    for filter in filters
      data = data.filter(filter)
    data

  _addFields: (data, fields) ->
    for field in fields
      data = data.map (i) ->
        i[field.field] = field.func(i); i
    data

  _dataKeys: (datum) =>
    keys = new Array
    keys.push key for key, value of datum when not(key in @nonDisplayKeys)
    keys

U.Paginated = 
  currentPageData: ->
    @currentPage(@opts.currentPage)
    @page(@opts.currentPage)

  page: (number) ->
    startIndex = number * _.result(@, 'perPage')
    endIndex = (number + 1) * _.result(@, 'perPage')
    sortedData = @pageSort(@preparedData())
    sortedData.slice(startIndex, endIndex)

  pages: ->
    Math.ceil(@pageSort(@preparedData()).length / _.result(@, 'perPage'))

  currentPage: (page) ->
    if _.isEmpty(@preparedData())
      return @opts.currentPage = page
    pages = @pages()
    if page < 0
      @opts.currentPage = pages - 1
    else if page >= pages
      @opts.currentPage = page % pages
    else if _.isNull(page) or _.isUndefined(page)
      @opts.currentPage = 0
    else
      @opts.currentPage = page

  nextPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) + 1

  prevPage: ->
    @settings

 # Abstract class for plots.  All plots should inherit from this object
class Graph 

  constructor: ->
    @format = d3.format(',.02f')
    @margin = {left: 70, top: 20, bottom: 80, right: 20}
    super

  events: 
    'height' : 'setupGraph drawAxis1 drawAxis2 drawData'
    'width' : 'setupGraph drawAxis1 drawAxis2 drawData'
    'settings' : 'drawAxis1 drawAxis2 drawData'
    'data' : 'drawAxis1 drawAxis2 drawData'
    'selector ' : 'setupGraph'

  setupGraph: =>
    return unless @opts.width? and @opts.height?

    unless @svg?
      @svg = @d3el.append('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 20)
        .attr('style', 'position: relative; top: 15px; left: -15px;')
        .append('g')
          .attr('class', 'chart')
          .attr('transform', 
            "translate(#{@margin.left}, #{@margin.top})")
    else
      @d3el.select('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

      @svg.select('g.chart')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

  graphWidth: =>
    @opts.width - (@margin.left + @margin.right)

  graphHeight: =>
    @opts.height - (@margin.top + @margin.bottom)

  xDomain: =>
    return unless @opts.axis1?
    domain = d3.extent _(@preparedData()).pluck(@opts.axis1)
    if @opts['x-min']
      domain[0] = @opts['x-min']
    if @opts['x-max']
      domain[1] = @opts['x-max']
    domain

  yDomain: =>
    return unless @opts.axis2?
    domain = d3.extent _(@preparedData()).pluck(@opts.axis2)
    if @opts['y-min']
      domain[0] = @opts['y-min']
    if @opts['y-max']
      domain[1] = @opts['y-max']
    domain

  x: =>
    domain = @xDomain()
    return unless domain?
    d3.scale.linear()
      .range([0, @graphWidth()])
      .domain(domain)

  y: =>
    domain = @yDomain()
    return unless domain?
    d3.scale.linear()
      .range([@graphHeight(), 0])
      .domain(domain)

  drawAxis1: =>
    return unless @opts.axis1? and not (_.isEmpty @preparedData())
    xAxis = d3.svg.axis()
      .scale(@x())
      .orient('bottom')
   
    @svg.select("g.x").remove()
    axis = @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight()})")
      .call(xAxis)

    @labelAxis1(axis)

  labelAxis1: (axis) =>
    axis.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth() / 2)
      .attr('y', 50)
      .text(@unitsFormatter(@formatKey(@opts.axis1)))
   
  drawAxis2: =>
    return unless @opts.axis2? and not (_.isEmpty @preparedData())
    yAxis = d3.svg.axis()
      .scale(@y())
      .orient('left')

    axis = @svg.select('g.y').remove()

    axis = @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    @labelAxis2(axis)

  labelAxis2: (axis) =>
    axis.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -40)
      .attr('x', -(@graphHeight() / 2))
      .attr('transform', "rotate(-90)")
      .text(@unitsFormatter(@formatKey(@opts.axis2)))
  
window.U.Graph = Graph      currentPage: parseInt(@opts.currentPage) - 1