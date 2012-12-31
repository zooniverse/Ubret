class Events
  constructor: (@events) ->
    @events = @events = new Object

  on: (event, callback) ->
    unless _.isArray @events[event]
      @events[event] = new Array
    @events[event].push callback

  trigger: (event, args...) ->
    if _.isArray @events[event]
      eventCallback(args...) for eventCallback in @events[event]

window.Ubret.Events = Events
