class Statistics extends U.Tool
  name: 'Statistics'
  className: "statistics"
  template: require('./templates/statistics')
  statistics: ['mean', 'median', 'mode', 'min', 'max', 'variance', 'standardDeviation', 'skew', 'kurtosis']

  settings: [require('tools/settings/keys')]
  
  constructor: ->
    @format = d3.format(',.03f')
    super

  events: [
    {
      req: ['data']
      opt: []
      fn: 'setKeys'
    },
    {
      req: ['data', 'key']
      opt: []
      fn: 'display'
    }
  ]
 
  setKeys: ({data}) ->
    @state.set('keys', data.keys())

  display: ({data, key}) -> 
    data = data.filter((d) -> d[key]?).project(key).toArray()
    @statData = _.pluck(data, key)
    @count = @statData.length
    @sum = _.reduce(@statData, ((m, n) -> m + n), 0)

    stats = _.map(@statistics, ((stat) -> @format(@[stat]())), @)
    stats = _.object(@statistics, stats)
                     
    @$el.html(@template({stats: stats, statKey: key}))

  # Statistics
  mean: ->
    @sum / @count

  median: ->
    midpoint = (@count / 2) - 1
    if midpoint % 1 is 0
      return @statData[midpoint]
    else
      top = Math.ceil midpoint
      bottom = Math.floor midpoint
      return (@statData[top] + @statData[bottom]) / 2

  mode: ->
    _.chain(@statData).countBy((num) -> num)
      .foldl(((memo, value, key) -> 
        if value > memo.value
          { key: key, value: value }
        else
          memo), {key: '', value: 0}).value().key

  min: ->
    _.min @statData

  max: ->
    _.max @statData

  variance: ->
    mean = @mean()
    varianceFormula = (memo, value) ->
      memo + Math.pow(Math.abs(value - mean), 2)
    variance = _.foldl @statData, varianceFormula, 0
    variance / @count

  standardDeviation: ->
    Math.sqrt @variance()

  skew: ->
    mean = @mean()
    standardDeviation = @standardDeviation()

    skewFormula = (memo, value) ->
      memo + Math.pow(value - mean, 3)
    sum = _.foldl @statData, skewFormula, 0

    denom = @count * Math.pow(standardDeviation, 3)
    sum / denom

  kurtosis: ->
    mean = @mean()
    standardDeviation = @standardDeviation()

    reduceAdd = (memo, value) ->
      memo + Math.pow(value - mean, 4)
    sum = _.foldl @statData, reduceAdd, 0

    denom = @count * Math.pow(standardDeviation, 4)
    sum / denom

module.exports = Statistics