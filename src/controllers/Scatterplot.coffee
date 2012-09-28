BaseController = require './BaseController'
_ = require 'underscore/underscore'

class Scatterplot extends BaseController
  constructor: ->
    super
    @height = @height or 480
    @width = @width or 640
    @margin = @margin or { left: 40, top: 20, bottom: 40 } 

    @xFormat = @xFormat or d3.format(',.0f')
    @yFormat = @yFormat or d3.format(',.0f')

  name: "Scatterplot"

  render: =>
    @html require('../views/scatterplot')(@)

  displayTooltip: (d, i) =>
    console.log d,i

  createGraph: =>
    if (typeof(@xAxisKey) is 'undefined') and (typeof(@yAxixKey) is 'undefined')
      return

    @el.find('svg').empty()

    graphWidth = @width - @margin.left
    graphHeight = @height - @margin.top - @margin.bottom

    svg = d3.select("##{@channel} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")

    if @filteredData.length isnt 0
      data = _.map(@filteredData, (d) => {x: d[@xAxisKey], y: d[@yAxisKey]})
      xDomain = d3.extent(data, (d) -> d.x)
      yDomain = d3.extent(data, (d) -> d.y)
    else
      data = []
      xDomain = [0, 10]
      yDomain = [0, 10]

    if typeof(@xAxisKey) isnt 'undefined'
      x = d3.scale.linear()
        .domain(xDomain)
        .range([0, graphWidth])

      xAxis = d3.svg.axis()
        .scale(x)
        .orient('bottom')
        .tickFormat(@xFormat)

      if data.length isnt 0
        xAxis.ticks(@calculateTicks(x))

      svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', "translate(0, #{graphHeight})")
        .call(xAxis)

      svg.append('text')
        .attr('class', 'x label')
        .attr('text-anchor', 'middle')
        .attr('x', graphWidth / 2)
        .attr('y', graphHeight + 30)
        .text(@prettyKey(@xAxisKey))

    if typeof(@yAxisKey) isnt 'undefined'
      y = d3.scale.linear()
        .domain(yDomain)
        .range([graphHeight, 0])

      yAxis = d3.svg.axis()
        .scale(y)
        .orient('left')
        .tickFormat(@yFormat)

      if data.length isnt 0
        ticks = @calculateTicks(y)
        console.log ticks
        yAxis.ticks(ticks)

      svg.append('g')
        .attr('class', 'y axis')
        .attr('transform', 'translate(0, 0)')
        .call(yAxis)

      svg.append('text')
        .attr('class', 'y label')
        .attr('text-anchor', 'middle')
        .attr('y', -30)
        .attr('x', -(graphHeight / 2))
        .attr('transform', "rotate(-90)")
        .text(@prettyKey(@yAxisKey))

    if data.length isnt 0
      point = svg.selectAll('.point')
        .data(data)
        .enter().append('g')
        .attr('class', 'point')
        .attr('transform', (d) -> "translate(#{x(d.x)}, #{y(d.y)})")
        .on('mouseover', @displayTooltip)

      point.append('circle')
        .attr('r', 3)

  calculateTicks: (axis) =>
    min = _.first axis.domain()
    max = _.last axis.domain()

    graphWidth = @width - @margin.left
    
    ticks = [min, max]
    numTicks = Math.floor(graphWidth/50)
    tickWidth = (max - min) / numTicks
    
    tick = min + tickWidth

    while tick < max
      ticks.push tick
      tick = tick + tickWidth
    return ticks

  setXVar: (variable) =>
    @xAxisKey = variable
    @createGraph()

  setYVar: (variable) =>
    @yAxisKey = variable
    @createGraph()

  start: =>
    @filterData()
    @createGraph()

module.exports = Scatterplot