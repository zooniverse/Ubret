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

  keys: (keys=[]) =>
    @opts.keys = keys
    @trigger 'keys-received', @opts.keys
    @
    
  selectIds: (ids=[]) =>
    if _.isArray ids
      @opts.selectedIds = ids
    else
      @opts.selectedIds.push ids unless _.isUndefined ids
    @trigger 'selection', ids unless ids.length is 0
    @

  selectKeys: (keys=[]) =>
    if _.isArray keys
      @opts.selectedKeys = keys
    else
      @opts.selectedKeys.push keys unless _.isUndefined keys
    @trigger 'keys-selection', keys
    @

  filters: (filters=[]) =>
    if _.isArray filters
      @opts.filters = filters
    else
      @opts.filters.push filters
    @trigger 'add-filters', filters
    @

  parentTool: (tool=null) =>
    if tool
      @opts.parentTool = tool
    if not _.isUndefined @opts.parentTool
      @data(tool.childData())
        .keys(tool.opts.keys)
        .selectIds(tool.opts.selectedIds)
        .selectKeys(tool.opts.selectedKeys)
      @opts.parentTool.on 'data-received', @data 
      @opts.parentTool.on 'selection', @selectIds
      @opts.parentTool.on 'set-keys', @selectKeys
      @opts.parentTool.on 'add-filter', @filters
      @trigger 'bound-to', tool
    @

  settings: (settings) =>
    unless _.isUndefined settings
      for setting, value of settings
        if typeof @[setting] is 'function'
          @[setting](value)
        else
          @opts[setting] = value
        @trigger 'update-setting', @opts[setting]
    @

  childData: ->
    @opts.data

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

window.Ubret.BaseTool = BaseTool