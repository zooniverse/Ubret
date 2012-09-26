BaseController = require './BaseController'

class Graph extends BaseController

  constructor: ->
    super

  createXAxis: (ticks=[], label='') =>
    xAxis = d3.svg.axis()
      .scale(@x)
      .orient('bottom')
      .tickFormat(d3.format(",.02f"))

    xAxis.tickValues(ticks) if ticks.length isnt 0

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
        .attr('x', 0)
        .attr('y', @graphHeight / 2)
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

    margin = {left: 30, right: 30, top: 40, bottom: 30}
    @graphWidth = @width - margin.left - margin.right
    @graphHeight = @height - margin.top - margin.bottom

    @svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.right})")

module.exports = Graph
