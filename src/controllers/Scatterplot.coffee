Graph = require './Graph'
_ = require 'underscore/underscore'

class Scatterplot extends Graph
  constructor: ->
    super

    @xAxisKey = @xAxisKey or 'ra'
    @yAxisKey = @yAxisKey or 'dec'
    @options =
      xFormat: ''
      yFormat: ''

  name: "Scatterplot"

  render: =>
    @html require('../views/scatterplot')(@)

  buildCoordinates: =>
    @coordinates = _.map @filteredData, (datum) =>
      return {x: datum[@xAxisKey], y: datum[@yAxisKey]}

  drawPoints: =>
    point = @svg.selectAll('.bar')
      .data(@coordinates)
      .enter().append('g')
      .attr('class', 'point')
      .attr('transform', (d) => "translate(#{@x(d.x)}, #{@y(d.y)})")

    point.append('circle')
      .attr('r', 2)

  createXAxis: (label, format) =>
    ticks = @calculateTicks(@x)
    super ticks, label, format

  createYAxis: (label, format) =>
    ticks = @calculateTicks(@y)
    super ticks, label, format
    
  calculateTicks: (axis) =>
    min = _.first axis.domain()
    max = _.last axis.domain()
    
    ticks = [min, max]
    numTicks = Math.floor(@graphWidth/50)
    tickWidth = (max - min) / numTicks
    
    tick = min + tickWidth

    while tick < max
      ticks.push tick
      tick = tick + tickWidth

    return ticks

  start: =>
    @filterData()
    @buildCoordinates()
    @createGraph()
    @createXScale(d3.min(@coordinates, (d) -> d.x), d3.max(@coordinates, (d) -> d.x))
    @createYScale(d3.min(@coordinates, (d) -> d.y), d3.max(@coordinates, (d) -> d.y))
    @createXAxis(@xAxisKey, @options.xFormat)
    @createYAxis(@yAxisKey, @options.yFormat)
    @drawPoints()

module.exports = Scatterplot