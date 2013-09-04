class Tool
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


