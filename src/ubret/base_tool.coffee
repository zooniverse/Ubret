class BaseTool
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb', 'plate', 'mjd', 'fiberID']

  constructor: ->
    _.extend @, Ubret.Events

    @opts = {}
    @opts.events = {}
    @opts.selectedKeys = []
    @opts.selectedIds = []
    @opts.data = []

    @unitsFormatter = d3.units 'astro'
    @setDefaults()
    @bindEvents @events

  setDefaults: ->
    @settings @defaults

  toJSON: ->
    json = {}
    json[key] = value for key, value of @opts when key isnt 'selector'
    json

  start: =>
    throw new Error "No Data" if _.isEmpty(@opts.data)
    throw new Error "Must Set Height" if _.isUndefined(@opts.height)
    @opts.selector = d3.select @selector
    @opts.width = @opts.selector[0][0].clientWidth
    @opts.selector.html ''

  selector: (selector=null, triggerEvent=true) ->
    if selector
      @el = document.createElement('div')
      @el.id = selector
      @opts.selector = d3.select @el
      @trigger 'selector', @opts.selector if triggerEvent
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
    @keys @dataKeys(@opts.data[0])
    @trigger 'data', @childData() if triggerEvent and (not _.isEmpty @opts.data)
    @

  keys: (keys=[], triggerEvent = true) =>
    @opts.keys = keys
    @trigger 'keys', @opts.keys if triggerEvent
    @
    
  selectIds: (ids=[], triggerEvent = true) =>
    if _.isArray ids
      @opts.selectedIds = ids
    else
      @opts.selectedIds.push ids unless _.isUndefined ids
    @trigger 'selection', ids unless ids.length is 0 if triggerEvent
    @

  selectKeys: (keys=[], triggerEvent = true) =>
    if _.isArray keys
      @opts.selectedKeys = keys
    else
      @opts.selectedKeys.push keys unless _.isUndefined keys
    @trigger 'keys-selection', keys if triggerEvent
    @

  filters: (filters=[], triggerEvent=true) =>
    if _.isArray filters
      @opts.filters = filters
    else
      @opts.filters.push filters
    @trigger 'add-filters', filters if triggerEvent
    @

  parentTool: (tool = null, triggerEvent=true) =>
    # Only bother checking sameness if parentTool is set.
    if @opts.parentTool?
      # Don't re-assign events if parentTool is the same
      if tool.selector is @opts.parentTool.selector
        return @
      else
        # Unbind events first if parentTool is different.
        @opts.parentTool.unbind()

    @opts.parentTool = tool

    @data(tool.childData())
      .selectIds(tool.opts.selectedIds)
      .selectKeys(tool.opts.selectedKeys)

    @opts.parentTool.on 
      'keys': @keys
      'data': @data 
      'selection': @selectIds
      'keys-selection': @selectKeys
      'add-filter': @filters
    @trigger 'bound-to', tool if triggerEvent
    @

  removeParentTool: =>
    if @opts.parentTool?
      @opts.parentTool.unbind()
      delete @opts.parentTool
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

  childData: ->
    @opts.data

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  dataKeys: (datum) =>
    keys = new Array
    keys.push key for key, value of datum when not(key in @nonDisplayKeys)
    keys

window.Ubret.BaseTool = BaseTool