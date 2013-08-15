Ubret.Events = 
  on: (event, callbacks) ->
    if _.isString event
        unless _.isArray @opts.events[event]
          @opts.events[event] = new Array
        if _.isFunction callbacks
          @opts.events[event].push callbacks
        else
          for callback in callbacks.split(' ')
            @opts.events[event].push @[callback]
    else if _.isObject event
      @bindEvents event

  trigger: (event, args...) ->
    if _.isArray @opts.events[event]
      eventCallback.apply(@, args) for eventCallback in @opts.events[event]
    if _.isArray @opts.events['*']
      eventCallback.apply(@, args) for eventCallback in @opts.events['*']

  unbind: (event = null, fn=null) ->
    # if event is null, unbind all events.
    unless event? then @opts.events = {}; return
    unless fn
      @opts.events = _.omit @opts.events, event
    else
      @opts.events = _.without(@opts.events[event], fn)

  # Private
  bindEvents: (events) ->
    for event, funcs of events
      @on event, funcs