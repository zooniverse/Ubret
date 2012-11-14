
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
    console.log 'Scatter2D'
    super opts
  
  draw: =>
    console.log 'Scatter2D draw'
    
    # Get data from crossfilter object
    data = @dimensions[@axis1].top(Infinity)
    data = _.map(data, (d) => _.pick(d, @axis1, @axis2))
    
    xDomain = @bufferAxes(d3.extent(data, (d) => d[@axis1]))
    yDomain = @bufferAxes(d3.extent(data, (d) => d[@axis2]))
    
    # Set up the x axis
    # Set up x axis
    @x = d3.scale.linear()
      .range([0, @graphWidth])
      .domain(xDomain)
    
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
      .domain(yDomain)

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
    
    @points = @svg.append('g').selectAll('circle')
        .data(data)
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