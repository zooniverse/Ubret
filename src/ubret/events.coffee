class Events
  constructor: ->
    @events = new Object

  on: (event, callback) ->
    unless _.isArray @events[event]
      @events[event] = new Array
    @events[event].push callback

  trigger: (event, args...) ->
    if _.isArray @events[event]
      eventCallback(args...) for eventCallback in @events[event]
    if _.isArray @events['*']
      eventCallback(args...) for eventCallback in @events['*']

  unbind: (event = null) ->
    # if event is null, unbind all events.
    unless event? then @events = {}; return
    @events = _.omit @events, event

window.Ubret.Events = Events