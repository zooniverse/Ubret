class Events
  constructor: ->
    @opts.events = new Object
    @bindEvents @events

  bindEvents: (events) =>
    for event, func of events
      func = @[func] if _.isString func
      @on event, func

  on: (events, callback) ->
    if _.isString events
      allEvents = events.split(' ')
      for event in allEvents
        unless _.isArray @opts.events[event]
          @opts.events[event] = new Array
        @opts.events[event].push callback
    else if _.isObject events
      @bindEvents events


  trigger: (event, args...) ->
    if _.isArray @opts.events[event]
      eventCallback(args...) for eventCallback in @opts.events[event]
    if _.isArray @opts.events['*']
      eventCallback(args...) for eventCallback in @opts.events['*']

  unbind: (event = null) ->
    # if event is null, unbind all events.
    unless event? then @opts.events = {}; return
    @opts.events = _.omit @opts.events, event

window.Ubret.Events = Events