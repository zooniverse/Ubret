U.listenTo = (eventEmitter, event, fn, ctx) ->
  eventEmitter.on(event, fn, ctx)

U.stopListening = (eventEmitter, event, fn, ctx) -> 
  eventEmitter.off(event, fn, ctx)

class U.EventEmitter
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
