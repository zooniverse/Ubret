Spine = require('spine')
pubSub = require('node-pubsub')
_ = require('underscore/underscore')

GalaxyZooSubject    = require('../models/GalaxyZooSubject')
SkyServerSubject    = require('../models/SkyServerSubject')
InteractiveSubject  = require('../models/InteractiveSubject')
SDSS3SpectralData   = require('../models/SDSS3SpectralData')


class BaseController extends Spine.Controller
  
  name: 'BaseController'
  
  constructor: ->
    super
    @data = new Array
    @filters = new Array
    @filteredData = new Array
    @selectedData = new Array
    @keys = new Array
    @bindOptions = new Object()

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
      when 'InteractiveSubject'
        dataSource = InteractiveSubject
      when 'SDSS3SpectralData'
        dataSource = SDSS3SpectralData
    
    dataSource.fetch(params).always =>
      @receiveData dataSource.lastFetch

  receiveData: (data) ->
    @data = data
    @start()
    @trigger 'data-received', @

  underscoresToSpaces: (string) ->
    string.replace /_/g, " "

  capitalizeWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  prettyKey: (key) ->
    @capitalizeWords(@underscoresToSpaces(key))

  spacesToUnderscores: (string) ->
    string.replace /\s/g, "_"

  lowercaseWords: (string) ->
    string.replace /(\b[A-Z])/g, (char) ->
      char.toLowerCase()

  uglifyKey: (key) ->
    @spacesToUnderscores(@lowercaseWords(key))

  bindTool: (source, params='') =>
    if params
      @bindOptions = {
          'source': source,
          'params': params
        }
      @getDataSource source, params
    else
      @bindOptions = {
          'source': source,
          'process': @process
        }
      @subscribe source, @process
    console.log @bindOptions

  extractKeys: (datum) ->
    undesiredKeys = ['id', 'cid', 'image', 'zooniverse_id', 'objID', 'counters', 'classification']
    for key, value of datum
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey in undesiredKeys

  filterData: =>
    @filteredData = @data
    for filter in @filters
      @filteredData = _.filter @filteredData, filter.func

  addFilter: (filter) =>
    @filters.push filter
    @publish [ {message: 'filter', filter: filter} ]
    @start()

  removeFilter: (filter) ->
    @filters = _.difference @filters, filter
    @publish [ {message: 'unfilter', filter: filter} ]
    @start()

  removeSelectionFilter: =>
    delete @selectionFilter
    @selectedData = new Array

  selectData: =>
    @selectedData = _.filter(@filteredData, @selectionFilter) if @selectionFilter

  process: (message) =>
    switch message.message
      when "selected" then @select message.item_id
      when "filter" then @addFilter message.filter
      when "unfilter" then @removeFilter message.filter

  start: =>
    @filterData()
    @selectData()

module.exports = BaseController