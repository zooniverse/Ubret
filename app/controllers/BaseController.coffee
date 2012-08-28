Spine = require('spine')
pubSub = require('node-pubsub')
GalaxyZooSubject = require('models/GalaxyZooSubject')
Settings = require('controllers/Settings')

class BaseController extends Spine.Controller
  constructor: ->
    super
    @settings = new Settings {tool: @}

  render: =>
    @html require('views/base_controller')()
    @append @settings.render()

  name: "BaseController"

  publish: (message) ->
    pubSub.publish(@channel, message, @)

  subscribe: (channel, callback) ->
    pubSub.subscribe(channel, callback)
    @trigger 'subscribed', channel
    
  getDataSource: (source, params) =>
    switch source
      when "GalaxyZooSubject" then dataSource = GalaxyZooSubject
    dataSource.fetch(params).onSuccess =>
      @data = dataSource.all()

  receiveData: (data) =>
    @data = data

  underscoresToSpaces: (string) ->
    string.replace "_", " "

  capitalizeWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  prettyKey: (key) ->
    @capitalizeWords(@underscoresToSpaces(key))

  bindTool: (source, params='') ->
    if params
      @getDataSource source, params
    else
      @subscribe source, @process
      @trigger "request-data-#{@channel}", source

module.exports = BaseController