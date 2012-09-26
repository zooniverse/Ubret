Graph = require './Graph'
_ = require 'underscore/underscore'

class Histogram extends Graph

  constructor: ->
    super
    @variable = @variable or 'extinction_u'

  createXAxis: =>
    xTicks = new Array
    xTicks.push datum.x for datum in @binnedData
    
    lastItem = _.last(@binnedData)
    lastTick = lastItem.x + lastItem.dx
    xTicks.push lastTick

    super xTicks, @variable

  binData: =>
    @values = _.map (@filteredData), (datum) =>
      parseFloat datum[@variable]
    @binnedData = d3.layout.histogram()(@values)

  drawBars: =>
    formatCount = d3.format ",.0f"

    bar = @svg.selectAll(".bar")
      .data(@binnedData)
      .enter().append('g')
      .attr('class', 'bar')
      .attr('transform', (d) => "translate(#{@x(d.x)}, #{@y(d.y) - 1})")

    bar.append('rect')
      .attr('x', 1)
      .attr('width', (@x(@binnedData[1].x) - @x(@binnedData[0].x) - 2))
      .attr('height', (d) => @graphHeight - @y(d.y))

    bar.append('text')
      .attr("dy", ".75em")
      .attr("y", 6)
      .attr("x", (@x(@binnedData[1].x) - @x(@binnedData[0].x)) / 2 )
      .attr("text-anchor", "middle")
      .text((d) -> formatCount(d.y))

  render: =>
    @html require('../views/histogram')(@channel)

  start: =>
    @filterData()
    @binData()
    @createGraph()
    @createXScale(d3.min(@values), d3.max(@values))
    @createYScale(0, d3.max(@binnedData, (d) -> d.y))
    @createXAxis([], '', d3.format(',.02f'))
    @createYAxis()
    @drawBars()

module.exports = Histogram