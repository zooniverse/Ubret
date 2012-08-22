Spine = require('spine')
pubSub = require('node-pubsub')

class BaseController extends Spine.Controller
  constructor: ->
    super
    @channel = @name + Math.random()
    pubSub.publish '/subscribe-able', [ { message: @channel } ]

  name: "BaseController"

  publish: (message) ->
    pubSub.publish(@channel, message, @)

  subscribe: (channel, callback) ->
    pubSub.subscribe(channel, callback)
    
module.exports = BaseController