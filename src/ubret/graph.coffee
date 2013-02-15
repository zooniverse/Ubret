# Abstract class for plots.  All plots should inherit from this object
class Graph extends Ubret.BaseTool

  constructor: (selector) ->
    super selector

    @opts.margin = @opts.margin or { left: 70, top: 20, bottom: 80, right: 20 }
    @opts.format = if @opts.format then d3.format(opts.format) else d3.format(',.02f')
    
    @opts.color = @opts.color or '#0172E6'
    @opts.selectionColor = @opts.selectionColor or '#CD3E20'

  setupGraph: =>
    # Check that all axes are defined
    for axis in [1..@axes]
      key = "axis#{axis}"
      return if @opts[key] in ["", undefined] # Check both since the class variable may be undefined or an empty string from selection
    
    @opts.selector.selectAll('svg').remove()
    
    @graphHeight = @opts.height - (@opts.margin.top + @opts.margin.bottom)
    @graphWidth  = @opts.width - (@opts.margin.left + @opts.margin.right)

    @svg = @opts.selector.append('svg')
      .attr('width', @graphWidth + @opts.margin.left)
      .attr('height', @graphHeight + @opts.margin.bottom)
      .append('g')
        .attr('transform', "translate(#{@opts.margin.left}, #{@opts.margin.top})")
      
    @setupData()  # Implemented by subclasses
    @drawAxes()
    @drawData()   # Implemented by subclasses
    @drawBrush()  # Implemented by subclasses
  
  start: =>
    super
    @setupGraph()
  
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
    
    @svg.append('g')
      .append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth / 2)
      .attr('y', @graphHeight + 50)
      .text(@formatKey(@opts.axis1))
    
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

    @svg.append('g')
      .append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -40)
      .attr('x', -(@graphHeight / 2))
      .attr('transform', "rotate(-90)")
      .text(@formatKey(@opts.axis2))
  
  bufferAxes: (domain) ->
    for border, i in domain
      if border > 0
        border = border - (border * 0.15)
      else
        border = border + (border * 0.15)

window.Ubret.Graph = Graph
