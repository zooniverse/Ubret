Graph = window.Ubret.Graph or require('./Graph')

class Histogram2 extends Graph
  name: 'Histogram'
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
    # Compute the number of bins for the unfiltered dataset
    @bins   = opts.bins
    @axis2  = opts.yLabel or 'Count'
  
    super opts

  setupData: =>
    # Get data from crossfilter object
    @createDimensions(@axis1)

    top       = @dimensions[@axis1].top(Infinity)
    data      = _.map(top, (d) => d[@axis1])
    @bins     = @bins or Math.floor(Math.log(@count) / Math.log(2) + 1)
    @xDomain  = d3.extent(data)
    @binSize  = (Math.ceil(@xDomain[1]) - Math.floor(@xDomain[0])) / @bins
    
    # Bin the data using crossfilter
    min = @xDomain[0]
    group = @dimensions[@axis1].group( (d) =>
      binNo = @bins
      while binNo > -1
        xValue = min + (@binSize * binNo)
        if d >= xValue
          return xValue
        binNo -= 1)
    @graphData = _.sortBy group.top(Infinity), (d) => d.key
    @yDomain = [0, d3.max(@graphData, (d) -> d.value)]

  drawData: =>
    @bars = @svg.append('g').selectAll('.bar')
      .data(@graphData)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('x', (d) => @x(d.key))
        .attr('width', @x(@graphData[1].key) - @x(@graphData[0].key))
        .attr('y', (d) => @y(d.value))
        .attr('height', (d) => @graphHeight - @y(d.value))
        .attr('fill', '#0071E5')
        .attr('stroke', '#FAFAFA')

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
    
    # Apply the filter
    @dimensions[@axis1].filter(d3.event.target.extent())
    
    top   = @dimensions[@axis1].top(Infinity)
    data  = _.pluck top, 'uid'
    @selectElements data
    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2