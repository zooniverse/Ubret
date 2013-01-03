class Statistics extends Window.BaseTool
  name: 'Statistics'
  
  constructor: (selector) ->
    super selector
    @opts.displayFormat = d3.format(',.03f')

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

    @title.text(@formatKey(@selectedKey))

    li = @ul.selectAll('li')
      .data(@statistics)
      .enter().append('li')
      .attr('data-stat', (d) -> d[0])
      .html((d) => "<label>#{@formatKey(d[0])}:</label> <span>#{@displayFormat(d[1])}</span>")

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
    _(@statData).countBy((num) -> num).foldl(((memo, value, key) -> 
      memo.value < value
      {key: key, value: value}), {key: 'uid', value: 0})
        .value().key

  min: =>
    _.min @statData

  max: =>
    _.max @statData

  variance: =>
    mean = @statistics.mean
    varianceFormula = (memo, value) =>
      memo + Math.pow(Math.abs(value - mean), 2)
    variance = _.foldl @statData, varianceFormula, 0
    variance / count

  standardDeviation: =>
    Math.sqrt @statistics.variance

  skew: =>
    mean = @statistics.mean
    standardDeviation = @statistics.standardDeviation

    skewFormula = (memo, value) =>
      memo + Math.pow(value - mean, 3)
    sum = _.foldl @statData, skewFormula, 0

    denom = @count * Math.pow(standardDeviation, 3)
    sum / denom

  kurtosis: =>
    mean = @statistics.mean
    standardDeviation = @statistics.standardDeviation

    reduceAdd = (p, v) =>
      p + Math.pow(v[@selectedKey] - mean, 4)
    sum = @dimensions.uid.groupAll().reduce(reduceAdd, reduceRemove, (p, v) -> 0).value()

    denom = @count * Math.pow(standardDeviation, 4)
    sum / denom

window.Ubret.Statistics = Statistics