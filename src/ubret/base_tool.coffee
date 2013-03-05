class BaseTool extends Ubret.Events
  constructor: ->
    @opts = {}
    super
    @opts.selectedKeys = []
    @opts.selectedIds = []
    @opts.unitsFormat = 'astro'
    @unitsFormatter = d3.units @opts.unitsFormat
    @opts.data = []
    @setDefaults()

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
      @opts.el = document.createElement('div')
      @opts.el.id = selector
      @opts.selector = d3.select @opts.el
      @trigger 'selector', @opts.selector if triggerEvent
    @

  height: (height=0, triggerEvent=true) ->
    @opts.height = height
    @trigger 'height', @opts.height
    @

  data: (data=[], triggerEvent=true) =>
    @opts.data = _(data).sortBy (d) -> d.uid
    @trigger 'data', @childData() if triggerEvent
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
      .keys(tool.opts.keys)
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
    unless _.isUndefined settings
      for setting, value of settings
        if typeof @[setting] is 'function'
          @[setting](value)
        else
          @opts[setting] = value
        @trigger "setting:#{setting}", value
      @trigger 'setting', settings if triggerEvent
    @

  childData: ->
    @opts.data

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

window.Ubret.BaseTool = BaseTool