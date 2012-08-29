pubSub = require('node-pubsub')
GalaxyZooSubject = require('models/GalaxyZooSubject')
SkyServerSubject = require('models/SkyServerSubject')
Settings = require('controllers/Settings')

class BaseController extends Spine.Controller
  
  events:
    'click a.settings-trigger' : 'toggleSettings'
  
  name: 'BaseController'
  
  constructor: ->
    super

  render: =>
    @html require('views/base_controller')()
    @append @settings.render()

  publish: (message) ->
    pubSub.publish(@channel, message, @)

  subscribe: (channel, callback) ->
    pubSub.subscribe(channel, callback)
    @trigger 'subscribed', channel
    
  getDataSource: (source, params) =>
    switch source
      when 'GalaxyZooSubject'
        dataSource = GalaxyZooSubject
      when 'SkyServerSubject'
        dataSource = SkyServerSubject
    
    dataSource.fetch(params).onSuccess =>
      @receiveData dataSource.lastFetch

  receiveData: (data) ->
    @data = data
    @start()

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

  toggleSettings: (e) =>
    e.preventDefault()
    @$el.toggleClass 'settings-active'

module.exports = BaseController