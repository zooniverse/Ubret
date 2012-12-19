BaseTool = window.Ubret.BaseTool or require('./base_tool')

class Statistics extends BaseTool
  name: 'Statistics'
  
  constructor: (opts) ->
    super opts
    @displayFormat = if opts.format then d3.format(opts.format) else d3.format(',.03f')

  start: =>
    super
    # Assign a selected key so the tool renders immediately.
    unless @selectedKey
      @selectedKey = 'uid'

    @createList()
    @createStats()
    @displayStats()

  createList: =>
    @wrapper = d3.select(@selector).append('div')
      .attr('class', 'stats')

    @title = @wrapper.append('h3')
      .attr('class', 'stat-key')

    @ul = @wrapper.append('ul')
      .attr('class', 'statistics')

  createStats: =>
    @createDimensions(@selectedKey)
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
    count = @dimensions.uid.groupAll().reduceCount().value()
    sum = @dimensions.uid.groupAll().reduce(((p, v) => p + v[@selectedKey]),
                                          ((p, v) => p - v[@selectedKey]), 
                                          ((p, v) -> 0))
                                            .value()
    sum / count

  median: =>
    count = @dimensions.uid.groupAll().reduceCount().value()

    # Check for odd length
    midPoint = count / 2
    if midPoint % 1
      topPoint = Math.ceil midPoint
      bottomPoint = Math.floor midPoint
      topPoint = _.last(@dimensions[@selectedKey].top(topPoint))[@selectedKey]
      bottomPoint = _.last(@dimensions[@selectedKey].top(bottomPoint))[@selectedKey]

      median = (topPoint + bottomPoint) / 2
    else
      median = @dimensions[@selectedKey].top(midPoint)
      median = _.last(median)[@selectedKey]
    median

  mode: =>
    mode = @dimensions[@selectedKey].group().reduceCount().top(1)
    console.log mode
    mode[0].key

  min: =>
    @dimensions[@selectedKey].bottom(1)[0][@selectedKey]

  max: =>
    @dimensions[@selectedKey].top(1)[0][@selectedKey]

  variance: =>
    count = @dimensions.uid.groupAll().reduceCount().value()
    mean = @mean()

    varianceFormulaAdd = (p, v) =>
      p + Math.pow(Math.abs(v[@selectedKey] - mean), 2)
    varianceFormulaRemove = (p, v) =>
      p - Math.pow(Math.abs(v[@selectedKey] - mean), 2)
    variance = @dimensions.uid.groupAll().reduce(varianceFormulaAdd, varianceFormulaRemove, (p, v) -> 0).value()

    variance / count

  standardDeviation: () =>
    Math.sqrt @variance()

  skew: =>
    mean = @mean()
    standardDeviation = @standardDeviation()
    count = @dimensions.uid.groupAll().reduceCount().value()

    reduceAdd = (p, v) =>
      p + Math.pow(v[@selectedKey] - mean, 3)
    reduceRemove = (p, v) =>
      p - Math.pow(v[@selectedKey] - mean, 3)
    sum = @dimensions.uid.groupAll().reduce(reduceAdd, reduceRemove, (p, v) -> 0).value()

    denom = count * Math.pow(standardDeviation, 3)
    sum / denom

  kurtosis: =>
    mean = @mean()
    standardDeviation = @standardDeviation()
    count = @dimensions.uid.groupAll().reduceCount().value()

    reduceAdd = (p, v) =>
      p + Math.pow(v[@selectedKey] - mean, 4)
    reduceRemove = (p, v) =>
      p - Math.pow(v[@selectedKey] - mean, 4)
    sum = @dimensions.uid.groupAll().reduce(reduceAdd, reduceRemove, (p, v) -> 0).value()

    denom = count * Math.pow(standardDeviation, 4)

    kurtosis = sum / denom

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Statistics
else
  window.Ubret['Statistics'] = Statistics