BaseController = require './BaseController'
_ = require 'underscore/underscore'

class Histogram extends BaseController

  constructor: ->
    super
    @variable = 'extinction_u'
    @width = 640
    @height = 480

  createGraph: =>
    if !@data.length
      @append "<p>No Data</p>"
      return

    width = @width
    height = @height

    formatCount = d3.format ",.0f"

    values = _.map (@filteredData), (datum) =>
      parseFloat datum[@variable]

    data = d3.layout.histogram()(values)
    
    y = d3.scale.linear()
      .domain([0, d3.max(data, (d) -> d.y)])
      .range([height, 0])

    x = d3.scale.linear()
      .domain([d3.min(values), d3.max(values)])
      .range([0, width])

    console.log data

    xValues = new Array
    xValues.push datum.x for datum in data
    console.log xValues

    xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')
      .tickValues(values)
      .tickFormat(d3.format(",.02f")

    yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

    svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.right})")

    bar = svg.selectAll(".bar")
      .data(data)
      .enter().append('g')
      .attr('class', 'bar')
      .attr('transform', (d) -> "translate(#{x(d.x)}, #{y(d.y)})")

    bar.append('rect')
      .attr('x', 1)
      .attr('width', (x(data[1].x) - x(data[0].x)))
      .attr('height', (d) -> height - y(d.y))

    bar.append('text')
      .attr("dy", ".75em")
      .attr("y", 6)
      .attr("x", (x(data[1].x) - x(data[0].x)) / 2 )
      .attr("text-anchor", "middle")
      .text((d) -> formatCount(d.y))

    svg.append('g')
      .attr('class', "x axis")
      .attr('transform', "translate(0, #{height})")
      .call(xAxis)

    svg.append('g')
      .attr('class', "y axis")
      .attr('transform', "translate(0,0)")
      .call(yAxis)

  render: =>
    @html require('../views/histogram')(@channel)

  start: =>
    @filterData()
    @createGraph()

module.exports = Histogram