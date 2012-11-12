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

  createGraph: =>
    graphHeight = @height - (@margin.top + @margin.bottom)
    graphWidth = @width - (@margin.left + @margin.right)

    @svg = d3.select(@selector)
      .append('svg')
      .attr('height', graphHeight)
      .attr('width', graphWidth)
  
  createXAxis: (dataSet, ticks) =>
    xDomain = d3.extent(dataSet, d -> d.x)
    xDomain = [0, 1] if xDomain.length is 0 

    @x = d3.scale.linear()
      .domain(xDomain)
      .range([0, @graphWidth])

    xAxis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')

  createYAxis: (dataSet, ticks) =>
    yDomain = d3.extent(dataSet, d -> d.y)
    yDomain = [0, 1] if yDomain.length is 0

    @y = d3.scale.linear()
      .domain(yDomain)
      .range(0)

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Graph
else
  window.Ubret['Graph'] = Graph
