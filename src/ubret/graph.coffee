# Abstract class for plots.  All plots should inherit from this object
class Graph extends Ubret.BaseTool

  constructor: ->
    @format = d3.format(',.02f')
    @margin = {left: 70, top: 20, bottom: 80, right: 20}
    super

  events: 
    'height' : 'setupGraph drawAxis1 drawAxis2 drawData'
    'width' : 'setupGraph drawAxis1 drawAxis2 drawData'
    'settings' : 'drawAxis1 drawAxis2 drawData'
    'data' : 'drawAxis1 drawAxis2 drawData'
    'selector ' : 'setupGraph'

  setupGraph: =>
    return unless @opts.width? and @opts.height?

    unless @svg?
      @svg = @d3el.append('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 20)
        .attr('style', 'position: relative; top: 15px; left: -15px;')
        .append('g')
          .attr('class', 'chart')
          .attr('transform', 
            "translate(#{@margin.left}, #{@margin.top})")
    else
      @d3el.select('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

      @svg.select('g.chart')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

  graphWidth: =>
    @opts.width - (@margin.left + @margin.right)

  graphHeight: =>
    @opts.height - (@margin.top + @margin.bottom)

  xDomain: =>
    return unless @opts.axis1?
    domain = d3.extent _(@preparedData()).pluck(@opts.axis1)
    console.log @opts
    if @opts['x-min']
      domain[0] = @opts['x-min']
    if @opts['x-max']
      domain[1] = @opts['x-max']
    domain
      

  yDomain: =>
    return unless @opts.axis2?
    domain = d3.extent _(@preparedData()).pluck(@opts.axis2)
    if @opts['y-min']
      domain[0] = @opts['y-min']
    if @opts['y-max']
      domain[1] = @opts['y-max']
    domain

  x: =>
    domain = @xDomain()
    return unless domain?
    d3.scale.linear()
      .range([0, @graphWidth()])
      .domain(domain)

  y: =>
    domain = @yDomain()
    return unless domain?
    d3.scale.linear()
      .range([@graphHeight(), 0])
      .domain(domain)

  drawAxis1: =>
    return unless @opts.axis1? and not (_.isEmpty @preparedData())
    xAxis = d3.svg.axis()
      .scale(@x())
      .orient('bottom')
   
    @svg.select("g.x").remove()
    axis = @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight()})")
      .call(xAxis)

    @labelAxis1(axis)

  labelAxis1: (axis) =>
    axis.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth() / 2)
      .attr('y', 50)
      .text(@unitsFormatter(@formatKey(@opts.axis1)))
   
  drawAxis2: =>
    return unless @opts.axis2? and not (_.isEmpty @preparedData())
    yAxis = d3.svg.axis()
      .scale(@y())
      .orient('left')

    axis = @svg.select('g.y').remove()

    axis = @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    @labelAxis2(axis)

  labelAxis2: (axis) =>
    axis.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -40)
      .attr('x', -(@graphHeight() / 2))
      .attr('transform', "rotate(-90)")
      .text(@unitsFormatter(@formatKey(@opts.axis2)))
  
window.Ubret.Graph = Graph
