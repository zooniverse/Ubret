# Implements Promises/A+ Spec at https://github.com/promises-aplus/promises-spec
class Promise
  constructor: ->
    @state = 'pending'
    @onFulfilledQueue = []
    @onRejectedQueue = []

  then: (onFulfilled=null, onRejected=null) =>
    child = new Promise()
    @onFulfilledQueue.push {func: onFulfilled, promise: child} if onFulfilled
    @onRejectedQueue.push {func: onRejected, promise: child} if onRejected
    if @state isnt 'pending'
      _.defer if @state is 'fulfilled' then @onFulfill else @onReject
    child

  fulfill: (value) =>
    return if @state isnt 'pending'
    @state = 'fulfilled'
    @value = value
    @onFulfill()

  reject: (reason) =>
    return if @state isnt 'pending'
    @state = 'rejected'
    @reason = reason 
    @onReject()

  onFulfill: =>
    return unless @state is 'fulfilled' and not _.isEmpty(@onFulfilledQueue)
    thenable = @onFulfilledQueue.shift()
    try
      value = thenable.func(@value)
      @resolveChild(thenable.promise, value)
    catch e
      @resolveChild(thenable.promise, e)
    @onFulfill()

  onReject: =>
    return unless @state is 'rejected' and not _.isEmpty(@onRejectedQueue)
    thenable = @onRejectedQueue.shift()
    try
      value = thenable.func(@reason)
      @resolveChild(thenable.promise, value)
    catch e
      @resolveChild(thenable.promise, e)
    @onReject()

  resolveChild: (child, value) =>
    if value instanceof Error 
      child.reject(value)
    else if _.isFunction(value?.then)
      Ubret.Assimilate(child, value)
    else
      child.fulfill(value)
 
window.Ubret.Promise = Promise

window.Ubret.Assimilate = (p1, p2) ->
  p1.state = p2.state
  if p1.state is 'fulfilled'
    p1.fulfill(p2.value)
  else if p1.state is 'rejected'
    p1.reject(p2.reason)
  else
    p2.then(p1.fulfill, p1.reject)
  p1
