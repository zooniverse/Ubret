BaseController = require './BaseController'

class Graph extends BaseController

  constructor: ->
    @width = @width or 640
    @height = @height or 480
    super

  createXAxis: (ticks=[], label='', format='') =>
    xAxis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')

    xAxis.tickValues(ticks) if ticks.length isnt 0
    xAxis.tickFormat(format) if typeof(format) is 'function'

    @svg.append('g')
      .attr('class', "x axis")
      .attr('transform', "translate(0, #{@graphHeight})")
      .call(xAxis)

    if label isnt ''
      @svg.append('text')
        .attr('class', 'x label')
        .attr('text-anchor', 'middle')
        .attr('x', @graphWidth / 2)
        .attr('y', @graphHeight + 35)
        .text(@prettyKey(label))

  createYAxis: (ticks=[], label ='', format='') =>
    yAxis = d3.svg.axis()
      .scale(@y)
      .orient('left')

    yAxis.tickValues(ticks) if ticks.length isnt 0
    yAxis.tickFormat(format) if typeof(format) is 'function'

    @svg.append('g')
      .attr('class', "y axis")
      .attr('transform', "translate(0,0)")
      .call(yAxis)

    if label isnt ''
      @svg.append('text')
        .attr('class', 'y label')
        .attr('text-anchor', 'middle')
        .attr('y', -30)
        .attr('x', -(@graphHeight / 2))
        .attr('transform', 'rotate(-90)')
        .text(@prettyKey(label))

  createXScale: (min=0, max=0) =>
    @x = d3.scale.linear()
      .domain([min, max])
      .range([0, @graphWidth])

  createYScale: (min=0, max=0) =>
    @y = d3.scale.linear()
      .domain([min, max])
      .range([@graphHeight, 0])

  createGraph: =>
    if !@data.length
      return

    margin = {left: 40, right: 30, top: 40, bottom: 30}
    @graphWidth = @width - margin.left - margin.right
    @graphHeight = @height - margin.top - margin.bottom

    @svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.right})")

    console.log @svg

module.exports = Graph
