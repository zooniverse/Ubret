class U.Tool
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']

  defaultEventHandlers: {
    'data' : ['childData'],
    'selection' : ['childSelection']
  }

  mixins: []

  settings: []

  events: []

  domEvents: {}

  constructor: (settings, parent=null) ->
    # Mixins
    _.each(@mixins, (mixin) => 
      _.extend(@constructor::, mixin))

    # Initialize Element
    @el = document.createElement('div')
    @el.className = "tool " + @className
    @d3el = d3.select(@el)
    @$el = $(@el)

    # Initialize State Watchers
    defaultEvents = _.chain(@defaultEventHandlers)
      .map((fns, ev) => [ev, _.map(fns, @_strToMethod, @)])
      .object().value()
    @state = new U.State({}, @, defaultEvents)
    @_setEvents()

    # Initialize Settings
    @settingViews = _.map(@settings, (setting) => new setting(@state))

    # Set Current State
    @setParent(parent) if parent
    @state.set(settings) if settings

  setParent: (parent) ->
    if @parent?
      _.each([['data', @setData], ['selection', @setSelection]], 
        ([ev, fn] => @state.off(ev, fn, @)))
    @parent = parent
    [childData, childSelection] = @parent.state.get('childData', 'childSelection')
    @state.set('data', childData) if childData?
    @state.set('selection', childSelection) if childSelection?

    @parent.state.when(['childData'], [], @setData, @)
    @parent.state.when(['childSelection'], [], @setSelection, @)

  setSelection: ({childSelection}) ->
    @state.set('selection', childSelection)

  setData: ({childData}) ->
    @state.set('data', childData) 

  setSize: (height, width) ->
    @state.set('height', height)
    @state.set('width', width)

  setSetting: (setting, value) ->
    if _.isFunction(@[setting])
      value = @[setting](value)
    @state.set(setting, value)
    value

  childData: (data) ->
    @state.set('childData', data)

  childSelection: (selection) ->
    @state.set('childSelection', selection)

  delegateEvents: ->
    _.each(@domEvents, (fn, ev) =>
      ev = ev.split(' ')
      selector = _.rest(ev).join(' ')
      ev = _.first(ev)
      @$el.on(ev, selector, _.bind(@[fn], @)))

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
