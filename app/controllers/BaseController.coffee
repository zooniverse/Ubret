Spine = require('spine')
pubSub = require('node-pubsub')
GalaxyZooSubject = require('models/GalaxyZooSubject')

class BaseController extends Spine.Controller
  constructor: ->
    super
    @channel = @name + Math.random()

  name: "BaseController"

  publish: (message) ->
    pubSub.publish(@channel, message, @)

  subscribe: (channel, callback) ->
    pubSub.subscribe(channel, callback)
    @trigger 'subscribed', channel
    
  getDataSource: (source, params) =>
    switch source
      when source = "GalaxyZooSubject" then dataSource = GalaxyZooSubject
    dataSource.fetch(params).onSuccess =>
      @data = dataSource.all()
      @render()

  recieveData: (data) =>
    @data = data
    @render()

module.exports = BaseController