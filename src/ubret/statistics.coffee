class Statistics extends Ubret.BaseTool
  name: 'Statistics'
  
  constructor: (selector) ->
    super selector
    @opts.displayFormat = ',.03f'

  events: 
    'selector' : 'createList'
    'data' : 'displayStats'
    'setting:statKey' : 'displayStats'

  createList: =>
    @wrapper = @d3el.append('div')
      .attr('class', 'stats')

    @title = @wrapper.append('h3')
      .attr('class', 'stat-key')

    @ul = @wrapper.append('ul')
      .attr('class', 'statistics')

  statistics: ['mean', 'median', 'mode', 'min', 'max', 'variance', 'standardDeviation', 'skew', 'kurtosis']

  displayStats: => 
    return unless @ul? and @opts.statKey? and !(_.isEmpty(@preparedData()))

    @statData = _.chain(@preparedData()).pluck(@opts.statKey).sort().value()
    @count = @statData.length
    @sum = _.foldl @statData, ((memo, num) -> memo + num), 0

    @ul.selectAll('li').remove()

    @title.text(@unitsFormatter(@formatKey(@opts.statKey)))

    li = @ul.selectAll('li')
      .data(@statistics)
      .enter().append('li')
      .attr('data-stat', (d) -> d[0])
      .html((d) => 
        stat = @[d]()
        if isNaN(stat) or stat is Infinity
          "<label>#{@formatKey(d)}:</label> <span>&nbsp</span>"
        else
          "<label>#{@formatKey(d)}:</label> <span>#{d3.format(@opts.displayFormat)(stat)}</span>")

  # Statistics
  mean: =>
    @sum / @count

  median: =>
    console.log(@statData)
    midpoint = (@count / 2) - 1
    if midpoint % 1 is 0
      return @statData[midpoint]
    else
      top = Math.ceil midpoint
      bottom = Math.floor midpoint
      return (@statData[top] + @statData[bottom]) / 2

  mode: =>
    _.chain(@statData).countBy((num) -> num)
      .foldl(((memo, value, key) -> 
        if value > memo.value
          { key: key, value: value }
        else
          memo), {key: '', value: 0}).value().key

  min: =>
    _.min @statData

  max: =>
    _.max @statData

  variance: =>
    mean = @mean()
    varianceFormula = (memo, value) =>
      memo + Math.pow(Math.abs(value - mean), 2)
    variance = _.foldl @statData, varianceFormula, 0
    variance / @count

  standardDeviation: =>
    Math.sqrt @variance()

  skew: =>
    mean = @mean()
    standardDeviation = @standardDeviation()

    skewFormula = (memo, value) =>
      memo + Math.pow(value - mean, 3)
    sum = _.foldl @statData, skewFormula, 0

    denom = @count * Math.pow(standardDeviation, 3)
    sum / denom

  kurtosis: =>
    mean = @mean()
    standardDeviation = @standardDeviation()

    reduceAdd = (memo, value) =>
      memo + Math.pow(value - mean, 4)
    sum = _.foldl @statData, reduceAdd, 0

    denom = @count * Math.pow(standardDeviation, 4)
    sum / denom

window.Ubret.Statistics = Statistics