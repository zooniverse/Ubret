BaseTool = window.Ubret.BaseTool or require('./base_tool')

# Abstract class for plots.  All plots should inherit from this object
class Graph extends BaseTool

  constructor: (opts) ->
    console.log 'Graph'
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

  setupAxes: =>
    console.log 'Graph setupAxes'
    
    # Check that all axes are defined
    for axis in [1..@axes]
      key = "axis#{axis}"
      return if @[key] is ""
    
    @el.find('svg').empty()
    
    @graphHeight = @height - (@margin.top + @margin.bottom)
    @graphWidth  = @width - (@margin.left + @margin.right)
    
    @svg = d3.select("#{@selector} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")
    
    @draw()
  
  start: => @setupAxes()

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Graph
else
  window.Ubret['Graph'] = Graph
