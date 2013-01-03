class BaseTool extends Ubret.Events
  constructor: (@selector) ->
    super
    @opts = new Object
    @opts.selectedKeys = new Array
    @opts.selectedIds = new Array

  toJSON: =>
    @opts

  start: =>
    console.log 'starting', @opts
    @opts.selector = d3.select @selector
    @opts.height = @opts.selector[0][0].clientHeight
    @opts.width = @opts.selector[0][0].clientWidth
    @opts.selector.html ''

  data: (data=[]) =>
    @opts.data = _(data).map (d) -> 
      d.uid = _.uniqueId()
      d
    @trigger 'data-received', @childData()
    @

  keys: (keys=[]) =>
    @opts.keys = keys
    @trigger 'keys-received', @opts.keys
    @
    
  selectIds: (ids=[]) =>
    if _.isArray ids
      console.log 'here'
      @opts.selectedIds = ids
      console.log @opts.selectedIds, ids
    else
      @opts.selectedIds.push ids
    @trigger 'selection', ids
    @

  selectKeys: (keys=[]) =>
    if _.isArray keys
      @opts.selectedKeys = keys
    else
      @opts.selectedKeys.push keys
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
      @opts.parentTool.on 'data-received', @data 
      @opts.parentTool.on 'selection', @selectElements
      @opts.parentTool.on 'set-keys', @selectKeys
      @opts.parentTool.on 'add-filter', @filters
      @trigger 'bound-to', tool
    @

  childData: =>
    @opts.data

  settings: (settings) =>
    for setting, value of settings
      if typeof @[setting] is 'function'
        @[setting](value)
      else
        @opts[setting] = value
      @trigger 'update-setting', @opts[setting]
    @

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

window.Ubret.BaseTool = BaseTool