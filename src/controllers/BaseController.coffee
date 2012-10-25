_ = require 'underscore/underscore'
pubSub = require 'node-pubsub'
Spine = require 'spine'

class BaseController extends Spine.Controller
  
  name: 'BaseController'
  
  constructor: (params) ->
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

  extractKeys: (datum) ->
    undesiredKeys = ['id', 'cid', 'image', 'zooniverse_id', 'objID', 'counters', 'classification']
    for key, value of datum
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey in undesiredKeys

  filterData: =>
    @filteredData = @data
    for filter in @filters
      @filteredData = _.filter @filteredData, filter.func

  # Pub-Sub functions
  select: (item_id) ->
    # By default, do nothing.
    return

  selectKey: (key) ->
    # By default, do nothing.
    return

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
      when 'selected' then @select message.item_id
      when 'filter' then @addFilter message.filter
      when 'unfilter' then @removeFilter message.filter
      when 'selected_key' then @selectKey message.key
      when 'receive_data' then @receiveData message.data

  start: =>
    @filterData()
    @selectData()

module.exports = BaseController