
Graph = window.Ubret.Graph or require('./Graph')

class Histogram2 extends Graph
  axes: 1
  
  template:
    """
    <div class="histogram">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """
  
  constructor: (opts) ->
    super opts
    
    # Compute the number of bins for the unfiltered dataset
    @bins = if opts.bins then opts.bins else Math.log(@count) / Math.log(2) + 1
    @axis2 = opts.yLabel or 'Count'
  
  setupData: =>
    # Get data from crossfilter object
    top     = @dimensions[@axis1].top(Infinity)
    data    = _.map(top, (d) => d[@axis1])
    @xDomain = d3.extent(data)
    @binSize = (@xDomain[1] - @xDomain[0]) / @bins
    
    # Bin the data using crossfilter
    group   = @dimensions[@axis1].group( (d) => Math.floor(d / @binSize))
    @data    = group.top(Infinity)
    @yDomain = [0, @data[0].value]
  
  drawData: =>
    
    @bars = @svg.selectAll('.bar')
        .data(@data)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('x', (d) => return @x((d.key + 1) * @binSize))
        .attr('width', @x(@binSize))
        .attr('y', (d) => return @y(d.value))
        .attr('height', (d) => return @graphHeight - @y(d.value))


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2