class U.Tool
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']

  defaultEventHandlers: {
    'data' : 'childData',
    'selection' : 'childSelection'
  }

  constructor: (settings, parent=null) ->
    # Initialize Element
    @el = document.createElement('div')
    @d3el = d3.select(@el)
    @$el = $(@el)

    # Initialize State Watchers
    defaultEvents = _.chain(@defaultEventHandlers)
      .pairs().map(([ev, fn]) => [ev, @_strToMethod(fn)])
      .object().value()
    @state = new U.State({}, @, defaultEvents)
    @_setEvents()

    # Set Current State
    @setParent(parent) if parent
    @state.set(settings)

  setParent: (parent) ->
    if @parent?
      _.each([['data', @setData], ['selection', @setSelection]], 
        ([ev, fn] => @state.off(ev, fn, @)))
    parent.state.when(['child-data'], [], @setData, @)
    parent.state.when(['child-selection'], [], @setSelection, @)

  setSelection: (selection) ->
    @state.set('selection', selection)

  setData: (data) ->
    @state.set('data', data)

  setSetting: (setting, value) ->
    if _.isFunction(@[setting])
      value = @[setting](value)
    @state.set(setting, value)

  childData: (data) ->
    @state.set('child-data', data)

  childSelection: (selection) ->
    @state.set('child-selection', selection)

  # Private

  _setEvents: ->
    _.each(@events, @_setEvent, @)

  _setEvent: ({req, opt, fn}) ->
    fn = @_strToMethod(fn) if _.isString(fn)
    @state.when(req, opt, fn, @)

  _strToMethod: (str) ->
    fn = @[str]
    throw new Error("Method #{str} is not defined") unless fn?
    fn
