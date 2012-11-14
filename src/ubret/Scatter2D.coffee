
Graph = window.Ubret.Graph or require('./Graph')

class Scatter2D extends Graph
  axes: 2
  
  template:
    """
    <div class="scatter-2d">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """
  
  constructor: (opts) ->
    super opts
  
  setupData: =>
    # Get data from crossfilter object
    data = @dimensions[@axis1].top(Infinity)
    @data = _.map(data, (d) => _.pick(d, @axis1, @axis2))
    
    @xDomain = @bufferAxes(d3.extent(@data, (d) => d[@axis1]))
    @yDomain = @bufferAxes(d3.extent(@data, (d) => d[@axis2]))
  
  drawData: =>
    @points = @svg.append('g').selectAll('circle')
        .data(@data)
      .enter().append('circle')
        .attr('class', 'dot')
        .attr('r', 1.5)
        .attr('cx', (d) => @x(d[@axis1]))
        .attr('cy', (d) => @y(d[@axis2]))
        .on('mouseover', @displayTooltip)
        .on('mouseout', @removeTooltip)
    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Scatter2D
else
  window.Ubret['Scatter2D'] = Scatter2D