class U.State extends U.EventEmitter
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
    if _.isObject(state)
      return @_setStateObj(state)
    [key, deepState] = @_parseStateStrToObj(state)
    unless _.isEqual(deepState[key], value)
      deepState[key] = value
      @trigger(state, value)

  with: (state, fn, ctx=null) ->
    if ctx?
      fn = _.bind(fn, ctx)
    return (=> fn(_.object(state, @get(state...))))

  when: (reqState, optState, fn, ctx) ->
    allState = _.flatten(reqState.concat(optState))
    withState = @with(allState, fn, ctx)
    checkStateAndExecute = () => 
      if _.every(@get(reqState...), ((s) -> s?), @)
        withState()
    _.each(allState, ((state) -> @on(state, checkStateAndExecute)), @)

  # Private Methods
  _setStateObj: (obj) ->
    _.each(@_parseStateObjToStrs(null, obj), (pair) => @set(pair...))

  _parseStateObjToStrs: (prefix, obj) ->
    _.reduce(obj, ((m, v, k) =>
      k = if _.isNumber(k) then "[" + k + "]" else k
      _prefix = if prefix? then prefix + "." + k else k
      if (_.isObject(v) || _.isArray(v))
        m.concat(@_parseStateObjToStrs(_prefix, v))
      else
        m.concat([[_prefix, v]])
    ), [])
  
  _parseStateStrToObj: (str) ->
    toAccessor = (a) ->
      array = a.match(/\[([0-9]+)\]/);
      return unless _.isNull(array) then parseInt(array[1]) else a

    state = str.split('.')
    finalKey = toAccessor(state.pop())

    stateRef = _.reduce(state, ((m, a, i) ->
      a = toAccessor(a)
      # Check if the key is defined. If not create it
      unless (m[a]?)
        nextKey = if (state.length is i + 1) then finalKey else state[i + 1]
        if (_.isNumber(nextKey)) then m[a] = [] else m[a] = {}
      m[a]
    ), @state)
    [finalKey, stateRef]
