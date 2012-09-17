BaseController = require './BaseController'
_ = require 'underscore/underscore'

class Histogram extends BaseController

  constructor: ->
    super
    @variable = 'extinction_u'
    @width = 640
    @height = 480

    @start()

  createGraph: =>
    if !@data.length
      @append "<p>No Data</p>"
      return

    margin = {top: 10, right: 30, bottom: 30, left: 30}
    width = @width - margin.left - margin.right
    height = @height - margin.top - margin.bottom

    formatCount = d3.format ",.of"

    values = _.map (@filteredData), (datum) =>
      datum[@variable] 

    data = d3.layout.histogram()(values)
    
    y = d3.scale.linear()
      .domain([0, d3.max(data, (d) -> d.y)])
      .range([height, 0])

    x = d3.scale.linear()
      .domain([Math.floor(d3.min(values)), Math.ceil(d3.max(values))])
      .range([width, 0])

    xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

    svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.right})")

    console.log((x(data[1].x) - x(data[0].x)))
    console.log(data)

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