
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
    @bins   = if opts.bins then opts.bins else Math.log(@count) / Math.log(2) + 1
    @axis2  = opts.yLabel or 'Count'
  
  setupData: =>
    # Get data from crossfilter object
    top       = @dimensions[@axis1].top(Infinity)
    data      = _.map(top, (d) => d[@axis1])
    @bins     = if @bins then @bins else Math.log(@count) / Math.log(2) + 1
    @xDomain  = d3.extent(data)
    @binSize  = (@xDomain[1] - @xDomain[0]) / @bins
    
    # Bin the data using crossfilter
    group = @dimensions[@axis1].group( (d) => Math.floor((d) / @binSize))
    @data    = group.top(Infinity)
    @yDomain = [0, @data[0].value]
  
  drawData: =>
    offset = Math.abs(_.min(@data, (d) -> return d.key).key)
    @bars = @svg.selectAll('.bar')
        .data(@data)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('x', (d) => return @x((d.key + offset) * @binSize))
        .attr('width', @x(@binSize))
        .attr('y', (d) => return @y(d.value))
        .attr('height', (d) => return @graphHeight - @y(d.value))

  drawBrush: =>
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', @graphWidth)
      .attr('height', @graphHeight)
      .call(d3.svg.brush().x(@x)
      .on('brushend', @brushend))
      .selectAll('rect')
      .attr('height', @graphHeight)
      .attr('opacity', 0.5)
      .attr('fill', '#CD3E20')

  brushend: =>
    
    # Clear existing filters
    for axis, dimension of @dimensions
      dimension.filterAll()
    
    # Apply the filter
    @dimensions[@axis1].filter(d3.event.target.extent())
    
    # Select all items within the range
    # TODO: Pass these data down the chain
    top   = @dimensions[@axis1].top(Infinity)
    data  = _.map(top, (d) => d[@axis1])
    
    console.log "min = ", Math.min.apply(Math, data)
    console.log "max = ", Math.max.apply(Math, data)
    console.log "len = ", data.length


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2