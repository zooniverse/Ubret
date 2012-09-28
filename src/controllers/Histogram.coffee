BaseController = require './BaseController'
_ = require 'underscore/underscore'

class Histogram extends BaseController

  constructor: ->
    super
    @height = @height or 480
    @width = @width or 640
    @margin = @margin or { left: 40, bottom: 70 }
    @format = @format or d3.format(',.02f')

  createGraph: =>
    if typeof(@variable) is 'undefined'
      return

    graphWidth = @width - @margin.left
    graphHeight = @height - @margin.bottom

    svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.bottom})")

    if @filteredData.length isnt 0
      bins = d3.layout.histogram()(_.map(@filteredData, (d) -> d[@variable]))
      xDomain = d3.extent(@filteredData, (d) -> d[@variable])
      yDomain= [0, d3.max(bins, (d) -> d.y)]
    else
      bins = []
      xDomain = [0, 1]
      yDomain = [0, 1]

    x = d3.scale.linear()
      .domain(xDomain)
      .range([0, graphWidth])

    y = d3.scale.linear()
      .domain(yDomain)
      .range([graphHeight, 0])

    xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    if bins.length isnt 0
      ticks = new Array
      ticks.push bin.x for bin in bins

      lastBin = _.last bins
      lastTick = lastBin.x + lastBin.dx
      ticks.push lastTick
    else
      ticks = [0, 0.25, 0.5, 0.75, 1]

    xAxis.tickValues(ticks)
    xAxis.tickFormat(@format)

    yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

    svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{graphHeight})")
      .call(xAxis)

    svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    svg.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', graphWidth / 2)
      .attr('y', graphHeight + 35)
      .text(@prettyKey(@variable))

    if bins.length isnt 0
      bar = svg.selectAll('.bar')
        .data(bins)
        .enter().append('g')
        .attr('class', 'bar')
        .attr('transform', (d) => "translate(#{x(d.x)}, #{y(d.y) - 1})")

      bar.append('rect')
        .attr('x', 1)
        .attr('width', (x(bins[1].x) - x(bins[0].x) - 2))
        .attr('height', (d) => graphHeight - y(d.y))

      bar.append('text')
        .attr("dy", ".75em")
        .attr("y", 6)
        .attr("x", (@x(bins[1].x) - x(bins[0].x)) / 2 )
        .attr("text-anchor", "middle")
        .text((d) -> formatCount(d.y))

  render: =>
    @html require('../views/histogram')(@channel)

  setVariable: (variable) =>
    @variable = variable
    @createGraph()

  start: =>
    @filterData()
    @createGraph()

module.exports = Histogram