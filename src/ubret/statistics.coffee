class Statistics extends Ubret.BaseTool
  name: 'Statistics'
  
  constructor: (selector) ->
    super selector
    @opts.displayFormat = ',.03f'

  start: =>
    super
    # Assign a selected key so the tool renders immediately.
    @statKey = @opts.selectedKeys[0] or 'uid'
    @statData = _.pluck @opts.data, @statKey

    @count = @statData.length
    @sum = _.foldl @statData, ((memo, num) -> memo + num), 0

    @createList()
    @createStats()
    @displayStats()

  createList: =>
    @wrapper = @opts.selector.append('div')
      .attr('class', 'stats')

    @title = @wrapper.append('h3')
      .attr('class', 'stat-key')

    @ul = @wrapper.append('ul')
      .attr('class', 'statistics')

  createStats: =>
    @statistics = new Array
    @statistics.push [stat, @[stat]()] for stat in ['mean', 'median', 'mode', 'min', 'max', 'variance', 'standardDeviation', 'skew', 'kurtosis']

  displayStats: => 
    @ul.selectAll('li').remove()

    @title.text(@formatKey(@statKey))

    li = @ul.selectAll('li')
      .data(@statistics)
      .enter().append('li')
      .attr('data-stat', (d) -> d[0])
      .html((d) => "<label>#{@formatKey(d[0])}:</label> <span>#{d3.format(@opts.displayFormat)(d[1])}</span>")

  # Statistics
  mean: =>
    @sum / @count

  median: =>
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