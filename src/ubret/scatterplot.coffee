try
  BaseTool = require './base_tool'
catch error
  BaseTool = window.Ubret.BaseTool

class Scatterplot extends BaseTool

  attributes:
    currentSubject:
      name: 'currentSubject'

  template:
    """
    <div id="<%- selector %>">
      <svg></svg>
    </div>
    """

  constructor: ->
    super
    compiled = _.template @template, {selector: @selector}
    @el.html compiled
    @height = @height or 480
    @width = @width or 640
    @margin = @margin or { left: 40, top: 20, bottom: 40 } 
    @color = @color or 'teal'
    @selectionColor = @selectionColor or 'orange'

    @xFormat = @xFormat or d3.format(',.02f')
    @yFormat = @yFormat or d3.format(',.02f')

  displayTooltip: (d, i) =>
    xAxis = @prettyKey(@xAxisKey)
    yAxis = @prettyKey(@yAxisKey)
    xAxisVal = @xFormat(d.x)
    yAxisVal = @yFormat(d.y)

    top = d3.event.pageY - 50
    left = d3.event.pageX

    @sendSelection(i)

    tooltip = require('../views/scatterplot_tooltip')({xAxis, yAxis, xAxisVal, yAxisVal})
    @append tooltip
    @el.find('.tooltip').offset({top: top, left: left})

  removeTooltip: (d, i) =>
    @el.find('.tooltip').remove()

  sendSelection: (index) =>
    selectedItem = @filteredData[index]
    @publish [ {message: "selected", item_id: selectedItem.zooniverse_id} ]

  select: (itemId) =>
    _.indexOf @filteredData itemId

  dataToCoordinates: (d) =>
    coordinate = {x: d[@xAxisKey], y: d[@yAxisKey], classification: d['classification']}
    if @selectedData? and d in @selectedData
      coordinate['color'] = @selectionColor
    else
      coordinate['color'] = @color
    return coordinate

  createGraph: =>
    if (typeof(@xAxisKey) is 'undefined') and (typeof(@yAxixKey) is 'undefined')
      return
    console.log 'creating graph'
    @el.find('svg').empty()
    console.log 'el', @el
    console.log 'channel', @selector

    @graphWidth = @width - @margin.left
    @graphHeight = @height - @margin.top - @margin.bottom

    @svg = d3.select("#{@selector} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")

    graphData = @drawAxes()
    @drawPoints(graphData, @color)

  drawAxes: =>
    if @data.length isnt 0
      data = _.map(@data, @dataToCoordinates)

      xDomain = d3.extent(data, (d) -> d.x)
      yDomain = d3.extent(data, (d) -> d.y)
    else
      data = []
      xDomain = [0, 10]
      yDomain = [0, 10]

    if typeof(@xAxisKey) isnt 'undefined'
      @x = d3.scale.linear()
        .domain(xDomain)
        .range([0, @graphWidth])

      xAxis = d3.svg.axis()
        .scale(@x)
        .orient('bottom')
        .tickFormat(@xFormat)

      if data.length isnt 0
        xAxis.tickValues(@calculateTicks(@x))

      @svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', "translate(0, #{@graphHeight})")
        .call(xAxis)

      @svg.append('text')
        .attr('class', 'x label')
        .attr('text-anchor', 'middle')
        .attr('x', @graphWidth / 2)
        .attr('y', @graphHeight + 30)
        .text(@prettyKey(@xAxisKey))

    if typeof(@yAxisKey) isnt 'undefined'
      @y = d3.scale.linear()
        .domain(yDomain)
        .range([@graphHeight, 0])

      yAxis = d3.svg.axis()
        .scale(@y)
        .orient('left')
        .tickFormat(@yFormat)

      if data.length isnt 0
        yAxis.tickValues(@calculateTicks(@y))

      @svg.append('g')
        .attr('class', 'y axis')
        .attr('transform', 'translate(0, 0)')
        .call(yAxis)

      @svg.append('text')
        .attr('class', 'y label')
        .attr('text-anchor', 'middle')
        .attr('y', -40)
        .attr('x', -(@graphHeight / 2))
        .attr('transform', "rotate(-90)")
        .text(@prettyKey(@yAxisKey))

    return data

  drawPoints: (data) =>
    if data.length isnt 0
      point = @svg.selectAll('.point')
        .data(data)
        .enter().append('g')
        .attr('class', 'point')
        .attr('transform', (d) =>
          if not d.x? or not d.y?
            return
          else
            "translate(#{@x(d.x)}, #{@y(d.y)})")
        .on('mouseover', @displayTooltip)
        .on('mouseout', @removeTooltip)

      point.append('circle')
        .attr('r', 3)
        .attr('id', (d) -> d.x)
        .attr('fill', (d) -> d.color)

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

  setXVar: (variable) =>
    @xAxisKey = variable
    @createGraph()

  setYVar: (variable) =>
    @yAxisKey = variable
    @createGraph()

  start: =>
    @createGraph()


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Scatterplot
else
  window.Ubret['Scatterplot'] = Scatterplot