# Abstract class for plots.  All plots should inherit from this object
class Graph extends Ubret.BaseTool

  constructor: ->
    super

    @opts.margin = @opts.margin or { left: 70, top: 20, bottom: 80, right: 20 }
    @opts.format = if @opts.format 
      d3.format(opts.format) 
    else
      d3.format(',.02f')
    @opts.color = @opts.color or '#0172E6'
    @opts.selectionColor = @opts.selectionColor or '#CD3E20'

  events: 
    'settings data width height' : 'drawAxis1'
    'settings data height width' : 'drawAxis2'
    'selector height width' : 'setupGraph'
    'data settings width height' : 'drawData'

  setupGraph: =>
    return unless @opts.width? and @opts.height?

    unless @svg?
      @svg = @opts.selector.append('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)
        .append('g')
          .attr('class', 'chart')
          .attr('transform', "translate(#{@opts.margin.left}, #{@opts.margin.top})")
    else
      @opts.selector.select('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

      @svg.select('g.chart')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)

  graphWidth: =>
    @opts.width - (@opts.margin.left + @opts.margin.right)

  graphHeight: =>
    @opts.height - (@opts.margin.top + @opts.margin.bottom)

  xDomain: =>
    return unless @opts.axis1?
    d3.extent _(@opts.data).pluck(@opts.axis1)

  yDomain: =>
    return unless @opts.axis2?
    d3.extent _(@opts.data).pluck(@opts.axis2)

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
    return unless @opts.axis1? and not (_.isEmpty @opts.data)
    xAxis = d3.svg.axis()
      .scale(@x())
      .orient('bottom')
   
    @svg.select("g.x").remove()
    axis = @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight()})")
      .call(xAxis)

    axis.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth() / 2)
      .attr('y', 50)
      .text(@unitsFormatter(@formatKey(@opts.axis1)))
   
  drawAxis2: =>
    return unless @opts.axis2? and not (_.isEmpty @opts.data)
    yAxis = d3.svg.axis()
      .scale(@y())
      .orient('left')

    axis = @svg.select('g.y').remove()

    axis = @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    axis.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -40)
      .attr('x', -(@graphHeight() / 2))
      .attr('transform', "rotate(-90)")
      .text(@unitsFormatter(@formatKey(@opts.axis2)))
  
window.Ubret.Graph = Graph
