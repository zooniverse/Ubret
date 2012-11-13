
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
    console.log 'Histogram2'
    super opts
    
    # Compute the number of bins for the unfiltered dataset
    @bins = if opts.bins then opts.bins else Math.log(@count) / Math.log(2) + 1
    @axis2 = opts.yLabel or 'Count'
  
  draw: =>
    console.log 'Histogram2 draw'
    
    # Get data from crossfilter object
    top     = @dimensions[@axis1].top(Infinity)
    data    = _.map(top, (d) => d[@axis1])
    extent  = d3.extent(data)
    binSize = (extent[1] - extent[0]) / @bins
    
    # Bin the data using crossfilter
    group = @dimensions[@axis1].group( (d) => Math.floor(d / binSize))
    data  = group.top(Infinity)
    ymax = data[0].value
    
    # Set up x axis
    @x = d3.scale.linear()
      .range([0, @graphWidth])
      .domain(extent)
    
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
      .domain([0, ymax])
    
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
    
    @bars = @svg.selectAll('.bar')
        .data(data)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('x', (d) => return @x((d.key + 1) * binSize))
        .attr('width', @x(binSize))
        .attr('y', (d) => return @y(d.value))
        .attr('height', (d) => return @graphHeight - @y(d.value))


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2