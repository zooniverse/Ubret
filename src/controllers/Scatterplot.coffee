Graph = require './Graph'
_ = require 'underscore/underscore'

class Scatterplot extends Graph
  constructor: ->
    super

    @xAxisKey = @xAxisKey or 'ra'
    @yAxisKey = @yAxisKey or 'dec'

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
        .attr('transform', (d) => "translate(#{@x(d.x)}, #{@y(d.y)}")

    point.append('circle')
      .attr('r', 5)

  start: =>
    @filterData()
    @buildCoordinates()
    @createGraph()
    @createXScale(d3.min(@coordinates, (d) -> d.x), d3.max(@coordinates, (d) -> d.x))
    @createYScale(d3.min(@coordinates, (d) -> d.y), d3.max(@coordinates, (d) -> d.y))
    @createXAxis([], @xAxisKey)
    @createYAxis([], @yAxisKey, d3.format(',.02f'))
    @drawPoints()

module.exports = Scatterplot