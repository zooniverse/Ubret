BaseTool = window.Ubret.BaseTool or require('./base_tool')

# Abstract class for plots.  All plots should inherit from this object
class Graph extends BaseTool

  constructor: (opts) ->
    console.log 'Graph'
    super opts
    
    # Load the template
    compiled = _.template @template, {selector: @selector}
    @el.html compiled
    
    @height = opts.width or @el.height()
    @width  = opts.height or @el.width()
    @margin = opts.margin or { left: 60, top: 20, bottom: 60, right: 40 }
    @format = if opts.format then d3.format(opts.format) else d3.format(',.02f')
    
    @color = opts.color or '#0172E6'
    @selectionColor = opts.selectionColor or '#CD3E20'

  setupAxes: =>
    console.log 'Graph setupAxes'
    
    # Check that all axes are defined
    for axis in [1..@axes]
      key = "axis#{axis}"
      return if @[key] is ""
    
    @el.find('svg').empty()
    
    graphHeight = @height - (@margin.top + @margin.bottom)
    graphWidth  = @width - (@margin.left + @margin.right)
    
    @svg = d3.select("#{@selector} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")

    # Set up x axis
    @x = d3.scale.linear()
      .range([0, graphWidth])
    
    @xAxis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')
    
    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{graphHeight})")
      .call(@xAxis)
    
    @svg.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', graphWidth / 2)
      .attr('y', graphHeight + 40)
      .text(@formatKey(@axis1))
    
    # Set up y axis
    @y = d3.scale.linear()
      .range([graphHeight, 0])
    
    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient('left')

    @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(@yAxis)

    @svg.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -60)
      .attr('x', -(graphHeight / 2))
      .attr('transform', "rotate(-90)")
      .text(@formatKey(@axis2))
    
    @draw()
  
  start: => @setupAxes()

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Graph
else
  window.Ubret['Graph'] = Graph
