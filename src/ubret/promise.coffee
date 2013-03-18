# Implements Promises/A+ Spec at https://github.com/promises-aplus/promises-spec
class Promsie
  constructor: ->
    @state = 'pending'
    @onFulfilledQueue = []
    @onRejectedQueue = []

  then: (onFulfilled=null, onRejected=null) ->
    @onFulfilledQueue.push onFulfilled if onFulfilled
    @onRejectedQueue.push onRejected if onRejected

  fulfill: (value) ->
    return if @state isnt 'pending'
    @state = 'fulfilled'
    @value = value

  reject: (reason) ->
    return if @state isnt 'pending'
    @state = 'rejected'
    @reason = reason 

  onFulfill: ->
    return unless @state is 'fulfilled' or _.isEmpty(@onFulliedQueue)
    @onFulfilledQueue.shift().apply(@, @value)
    @onFulfill()

  onReject: ->
    return unless @state is 'rejected' or _.isEmpty(@onRejectedQueue)
    @onRejectedQueue.shift().apply(@, @reason)
    @onReject()

Ubret.Promise = Promise
