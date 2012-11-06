try
  BaseTool = require './base_tool'
catch error
  BaseTool = window.Ubret.BaseTool

class Histogram extends BaseTool
  
  template:
    """
    <div class="histogram">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """

  constructor: ->
    super
    compiled = _.template @template, {selector: @selector}
    @el.html compiled

    @height = @height or 480
    @width = @width or 640
    @margin = @margin or { left: 40, top: 20, bottom: 40 } 
    @format = @format or d3.format(',.02f')
    @color = @color or 'teal'
    @selectionColor = @selectionColor or 'orange'
    @yLabel = @yLabel or 'Number'

    @createGraph()

  createGraph: =>
    @variable = 'dec'
    @selectedData = []
    if typeof(@variable) is 'undefined'
      return

    @el.find('svg').empty()

    @graphWidth = @width - @margin.left
    @graphHeight = @height - @margin.top - @margin.bottom
    @formatCount = d3.format(',.0f')

    @svg = d3.select("#{@selector} svg")
      .attr('width', @width)
      .attr('height', @height)
      .append('g')
        .attr('transform', "translate(#{@margin.left}, #{@margin.top})")

    if @data.length > 1
      data = _.map(@data, (d) => d[@variable])
      data = _.filter(data, (d) => d isnt null)

      if @binNumber?
        bins = d3.layout.histogram().bins(@binNumber)(data)
      else
        bins = d3.layout.histogram()(data)
      xDomain = d3.extent(@data, (d) => parseFloat(d[@variable]))
      yDomain= [0, d3.max(bins, (d) -> d.y)]
    else if @data.length is 1
      svg.append('text')
        .attr('class', 'data-warning')
        .attr('y', graphHeight / 2)
        .attr('x', graphWidth / 2)
        .attr('text-anchor', 'middle')
        .text('Not Enough Data, Classify More Galaxies!')
      return
    else
      bins = []
      xDomain = [0, 1]
      yDomain = [0, 1]

    if @selectedData.length isnt 0
      binRanges = _.map(bins, (d) -> d.x)
      binFunction= d3.layout.histogram()
        .bins(binRanges)

      unselectedData = _.filter(@filteredData, (d) => not (d in @selectedData))
      selectedData = _.map(@selectedData, (d) => d[@variable])
      unselectedData = _.map(unselectedData, (d) => d[@variable]) 

      unselectedBin = binFunction(unselectedData)
      selectedBin = binFunction(selectedData)

      yDomain = [0, d3.max([d3.max(unselectedBin, (d) -> d.y), d3.max(selectedBin, (d) -> d.y)])]

    @x = d3.scale.linear()
      .domain(xDomain)
      .range([0, @graphWidth])

    @y = d3.scale.linear()
      .domain(yDomain)
      .range([@graphHeight, 0])

    xAxis = d3.svg.axis()
      .scale(@x)
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
      .scale(@y)
      .orient('left')

    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight})")
      .call(xAxis)

    @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(0, 0)")
      .call(yAxis)

    @svg.append('text')
      .attr('class', 'x label')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth / 2)
      .attr('y', @graphHeight + 35)
      .text(@prettyKey(@variable))

    @svg.append('text')
      .attr('class', 'y label')
      .attr('text-anchor', 'middle')
      .attr('y', -40)
      .attr('x', -(@graphHeight / 2))
      .attr('transform', "rotate(-90)")
      .text(@yLabel)

    if bins.length isnt 0
      if @selectedData.length isnt 0
        @drawBars unselectedBin, @color, true if unselectedData.length > 1
        @drawBars selectedBin, @selectionColor, true, true if selectedData.length > 1
      else 
        @drawBars bins, @color

  drawBars: (bins, color, halfSize = false, offset = false) => 
    width = @x(bins[1].x) - @x(bins[0].x) 
    width = if halfSize then (width / 2) - 1 else width - 2 
    witth = if offset then width - 1 else width

    bar = @svg.selectAll(".bar-#{color}")
      .data(bins)
      .enter().append('g')
      .attr('class', 'bar')
      .attr('transform', (d) => 
        if offset
          "translate(#{@x(d.x) + (width) + 1}, #{@y(d.y) - 1})"
        else
          "translate(#{@x(d.x)}, #{@y(d.y) - 1})" )

    bar.append('rect')
      .attr('x', 1)
      .attr('width', Math.floor(width))
      .attr('height', (d) => @graphHeight - @y(d.y))
      .attr('fill', color)

    bar.append('text')
      .attr("dy", ".75em")
      .attr("y", 6)
      .attr("x", (width / 2))
      .attr("text-anchor", "middle")
      .text((d) => @formatCount(d.y))

  setVariable: (variable) =>
    @variable = variable
    @createGraph()

  start: =>
    super
    @createGraph()


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram
else
  window.Ubret['Histogram'] = Histogram