class BaseTool extends Ubret.Events
  constructor: (@selector) ->
    super
    @opts = new Object
    @opts.selectedKeys = new Array
    @opts.selectedIds = new Array

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @opts when key isnt 'selector'
    json

  start: =>
    @opts.selector = d3.select @selector
    @opts.height = @opts.selector[0][0].clientHeight
    @opts.width = @opts.selector[0][0].clientWidth
    @opts.selector.html ''

  data: (data=[]) =>
    @opts.data = _(data).sortBy (d) -> d.uid
    @trigger 'data-received', @childData()
    @

  keys: (keys=[], triggerEvent = true) =>
    @opts.keys = keys

    if triggerEvent
      @trigger 'keys-received', @opts.keys
    @
    
  selectIds: (ids=[], triggerEvent = true) =>
    if _.isArray ids
      @opts.selectedIds = ids
    else
      @opts.selectedIds.push ids unless _.isUndefined ids

    if triggerEvent
      @trigger 'selection', ids unless ids.length is 0
    @

  selectKeys: (keys=[], triggerEvent = true) =>
    if _.isArray keys
      @opts.selectedKeys = keys
    else
      @opts.selectedKeys.push keys unless _.isUndefined keys

    if triggerEvent
      @trigger 'keys-selection', keys
    @

  filters: (filters=[]) =>
    if _.isArray filters
      @opts.filters = filters
    else
      @opts.filters.push filters
    @trigger 'add-filters', filters
    @

  parentTool: (tool = null) =>
    unless tool then return @opts.parentTool

    # Only bother checking sameness if parentTool is set.
    if @opts.parentTool?
      # Don't re-assign events if parentTool is the same
      if tool.selector is @opts.parentTool.selector
        return @
      else
        # Unbind events first if parentTool is different.
        @opts.parentTool.unbind()

    @opts.parentTool = tool

    @opts.parentTool.on 'keys-received', @keys
    @opts.parentTool.on 'data-received', @data 
    @opts.parentTool.on 'selection', @selectIds
    @opts.parentTool.on 'keys-selection', @selectKeys
    @opts.parentTool.on 'add-filter', @filters

    @data(tool.childData())
      .keys(tool.opts.keys)
      .selectIds(tool.opts.selectedIds)
      .selectKeys(tool.opts.selectedKeys)

    @trigger 'bound-to', tool
    @

  settings: (settings) =>
    obj = {}
    unless _.isUndefined settings
      for setting, value of settings
        if typeof @[setting] is 'function'
          @[setting](value)
        else
          @opts[setting] = value

        # This might not be 100% solid.
        obj[setting] = value
        @trigger 'update-setting', obj
    @

  childData: ->
    @opts.data

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

window.Ubret.BaseTool = BaseTool