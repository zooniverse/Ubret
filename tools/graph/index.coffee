class Graph extends U.Tool
  events: [
    {
      req: ['height', 'width']
      opt: []
      fn: 'setupGraph'
    },
    {
      req: ['data', 'xAxis', 'yAxis']
      opt: ['xMin', 'yMin', 'xMax', 'yMax']
      fn: 'graphData'
    },
    {
      req: ['graphData', 'xAxis', 'yAxis', 'xScale', 'yScale', 'height', 'width']
      opt: ['selection']
      fn: 'drawGraph'
    },
    {
      req: ['graphData', 'xAxis', 'width','height']
      opt: ['xMin', 'xMax']
      fn: 'xScale'
    },
    {
      req: ['graphData', 'yAxis', 'height', 'width']
      opt: ['yMin', 'yMax']
      fn: 'yScale'
    },
    {
      req: ['xScale', 'height', 'width']
      opt: []
      fn: 'drawXAxis'
    },
    {
      req: ['yScale', 'height']
      opt: []
      fn: 'drawYAxis'
    },
    {
      req: ['data']
      opt: []
      fn: 'setKeys'
    }
  ]

  graphEvents: []

  constructor: ->
    @events = @events.concat(@graphEvents)
    @format = d3.format(',.02f')
    @marginLeft = 60
    @marginTop = 50
    super

  setupGraph: ({height, width}) ->
    unless @svg?
      @svg = @d3el.append('svg')
        .attr('width', width - @marginLeft)
        .attr('height', height - @marginTop)
        .attr('transform', "translate(0, 5)")

      @chart = @svg.append('g')
        .attr('class', 'chart')
        .attr('transform', "translate(#{@marginLeft}, 0)")

    else
      @d3el.select('svg')
        .attr('width', width - @marginLeft)
        .attr('height', height - @marginTop)

  xScale: ({graphData, xAxis, xMin, xMax, height, width}) ->
    domain = @domain(graphData, xAxis, xMin, xMax)
    scale = d3.scale.linear().range([0, width - @marginLeft]).domain(domain)
    @state.set('xScale', scale)
    
  yScale: ({graphData, yAxis, yMin, yMax, height, width}) ->
    domain = @domain(graphData, yAxis, yMin, yMax)
    scale = d3.scale.linear().range([height - @marginTop, 0]).domain(domain)
    @state.set('yScale', scale)

  domain: (data, axis, min, max) ->
    domain = d3.extent(_.pluck(data, axis))
    domain[0] = min if min? 
    domain[1] = max if max?
    domain

  drawXAxis: ({xScale, width, height}) ->
    xAxis = d3.svg.axis()
      .scale(xScale)
      .tickFormat(@format)
      .orient('bottom')
   
    @svg.select("g.x").remove()
    axis = @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(#{@marginLeft}, #{height - @marginTop})")
      .call(xAxis)

    @labelXAxis(axis, width)

  labelXAxis: (axis, width) ->
    xaxis = @state.get('xAxis')[0]
    axis.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', (width - @marginLeft) / 2)
      .attr('y', 40)
      .text(xaxis)
   
  drawYAxis: ({yScale, height}) ->
    yAxis = d3.svg.axis()
      .tickFormat(@format)
      .scale(yScale)
      .orient('left')

    axis = @svg.select('g.y').remove()

    axis = @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(#{@marginLeft}, 0)")
      .call(yAxis)

    @labelYAxis(axis, height)

  labelYAxis: (axis, height) ->
    yaxis = @state.get('yAxis')[0]
    axis.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -50)
      .attr('x', -(height - @marginTop) / 2)
      .attr('transform', "rotate(-90)")
      .text(yaxis)

  setKeys: ({data}) ->
    @state.set('keys', data.keys())

module.exports = Graph
