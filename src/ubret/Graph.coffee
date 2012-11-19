BaseTool = window.Ubret.BaseTool or require('./base_tool')

# Abstract class for plots.  All plots should inherit from this object
class Graph extends BaseTool

  constructor: (opts) ->
    super opts
    
    # Load the template
    compiled = _.template @template, {selector: @selector}
    @el.html compiled
    
    @width  = opts.width or @el.width()
    @height = opts.height or @el.height()
    @margin = opts.margin or { left: 60, top: 20, bottom: 60, right: 40 }
    @format = if opts.format then d3.format(opts.format) else d3.format(',.02f')
    
    @color = opts.color or '#0172E6'
    @selectionColor = opts.selectionColor or '#CD3E20'

  setupGraph: =>
    
    # Check that all axes are defined
    for axis in [1..@axes]
      key = "axis#{axis}"
      return if @[key] in ["", undefined] # Check both since the class variable may be undefined or an empty string from selection
    
    @el.find('svg').empty()
    
    @graphHeight = @height - (@margin.top + @margin.bottom)
    @graphWidth  = @width - (@margin.left + @margin.right)
    
    @svg = d3.select("#{@selector} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")
    
    @clearFilters()
    @setupData()  # Implemented by subclasses
    @drawAxes()
    @drawData()   # Implemented by subclasses
    @drawBrush()
  
  start: =>
    @setupGraph()
  
  clearFilters: =>
    for key, dimension of @dimensions
      dimension.filterAll()
  
  drawAxes: =>
    
    # Set up x axis
    @x = d3.scale.linear()
      .range([0, @graphWidth])
      .domain(@xDomain)
    
    xAxis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')
    
    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight})")
      .call(xAxis)
    
    @svg.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth / 2)
      .attr('y', @graphHeight + 40)
      .text(@formatKey(@axis1))
    
    # Set up y axis
    @y = d3.scale.linear()
      .range([@graphHeight, 0])
      .domain(@yDomain)
    
    yAxis = d3.svg.axis()
      .scale(@y)
      .orient('left')

    @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    @svg.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -60)
      .attr('x', -(@graphHeight / 2))
      .attr('transform', "rotate(-90)")
      .text(@formatKey(@axis2))
  
  bufferAxes: (domain) ->
    for border, i in domain
      if border > 0
        border = border - (border * 0.15)
      else
        border = border + (border * 0.15)

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Graph
else
  window.Ubret['Graph'] = Graph
