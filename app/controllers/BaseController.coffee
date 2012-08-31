Spine = require('spine')
pubSub = require('node-pubsub')
_ = require('underscore/underscore')

GalaxyZooSubject = require('models/GalaxyZooSubject')
SkyServerSubject = require('models/SkyServerSubject')

Settings = require('controllers/Settings')

class BaseController extends Spine.Controller
  
  name: 'BaseController'
  
  constructor: ->
    super

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

    dataSource.fetch(params).always =>
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

  spacesToUnderscores: (string) ->
    string.replace " ", "_"

  lowercaseWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toLowerCase()

  uglifyKey: (key) ->
    @spacesToUnderscores(@lowercaseWords(key))

  bindTool: (source, params='') ->
    if params
      @getDataSource source, params
    else
      @subscribe source, @process

  extractKeys: (datum) ->
    undesiredKeys = ['id', 'cid', 'image', 'zooniverse_id', 'objID']
    for key, value of datum
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey in undesiredKeys

  parseFilter: (string) =>
    tokens = string.split " "
    filter = @processFilterArray tokens
    filter = "return" + filter.join " "
    filterFunc = new Function( "item", filter )

  processFilterArray: (tokens, filters=[]) =>
    nextOr = _.indexOf tokens, "or"
    nextAnd = _.indexOf tokens, "and"
    if ((nextOr < nextAnd) or (nextAnd == -1)) and (nextOr != -1)
      predicate = tokens.splice(0, nextOr)
      filters.push @parsePredicate predicate
      filters.push "||"
    else if ((nextAnd < nextOr) or (nextOr == -1)) and (nextAnd != -1)
      predicate = tokens.splice(0, nextAnd)
      filters.push @parsePredicate predicate
      filters.push "&&"
    else
      predicate = tokens 
      filters.push @parsePredicate predicate
    unless predicate == tokens
      @processFilterArray tokens.splice(1), filters 
    else
      return filters

  parsePredicate: (predicate) ->
    field = _.first predicate
    limiter = _.last predicate
    comparison = _.find predicate, (item) ->
      item in ['equals', 'greater', 'less', 'not', '=', '>', '<', '!=']

    switch comparison
      when 'equals' then operator = '==='
      when 'greater' then operator = '>'
      when 'less' then operator = '<'
      when 'not' then operator = '!=='
      when '=' then operator = '==='
      else operator = comparison

    return "(item['#{@uglifyKey(field)}'] #{operator} #{parseFloat(limiter)})"

  filterData: =>
    @filteredData = @data
    for func in @filters
      @filteredData = _.filter @data, func

module.exports = BaseController