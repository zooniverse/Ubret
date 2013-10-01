Graph = require('tools/graph')

class Histogram extends Graph
  name: 'Histogram'
  className: 'histogram'

  settings: [require('tools/settings/x_axis_key'),
             require('tools/settings/x_axis_min_max')]
  
  constructor: (settings, parent) ->
    @events[1].opt = @events[1].opt.concat('bins')
    settings.yAxis = 'count'
    super settings, parent

  graphData: ({data, xAxis, yAxis, xMin, xMax, bins}) ->
    binFunc = d3.layout.histogram() 
    binFunc = binFunc.bins(bins) if bins
    data = data.project(xAxis)
    data = data.filter((d) -> d[xAxis] >= xMin) if xMin
    data = data.filter((d) -> d[xAxis] <= xMax) if xMax
    data = data.toArray()
    @state.set('graphData', binFunc(_.pluck(data, xAxis)))

  yScale: ({graphData, height}) ->
    domain = [0, d3.max(graphData, (d) -> d.y)]
    scale = d3.scale.linear().range([height - @marginTop, 0]).domain(domain)
    @state.set('yScale', scale)

  xScale: (state) ->
    [data] = @state.get('data')
    data = data.filter((d) -> d[state.xAxis] >= state.xMin) if state.xMin
    data = data.filter((d) -> d[state.xAxis] <= state.xMax) if state.xMax
    data = data.toArray()
    state.graphData = data
    super state

  drawGraph: ({graphData, xAxis, xScale, yScale, selection, height, width}) ->
    barWidth = xScale(graphData[1].x) - xScale(graphData[0].x)

    bars = @chart.selectAll('g.bar')
      .data(graphData, (d) -> d.x)

    bars.enter().append('g')
      .attr("class", 'bar')
      .append("rect")

    bars.selectAll("rect")
      .attr('width', barWidth) 
      .attr('height', (d) => (height - @marginTop) - yScale(d.y))
      .attr('x', (d) -> xScale(d.x))
      .attr('y', (d) -> yScale(d.y))

    bars.exit().remove()

    @drawBrush(xScale, height, width)

  drawBrush: (xScale, height, width) ->
    @brush.remove() if @brush
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', width - @marginLeft)
      .attr('height', height - @marginTop)
      .attr('transform', "translate(#{@marginLeft}, 0)")
      .call(d3.svg.brush().x(xScale).on('brushend', @brushend))
        .selectAll('rect')
        .attr('height', height - @marginTop)
        .attr('opacity', 0.5)
        .attr('fill', '#CD3E20')

  brushend: =>
    [data, xAxis] = @state.get('data', 'xAxis')
    x = d3.event.target.extent()
    selected = data.project('uid')
      .filter( (d) -> (d[xAxis] > x[0]) and (d[xAxis] < x[1]))
    @state.set('selection', _.pluck(selected.toArray(), 'uid'))

  drawXAxis: ({xScale}) ->
    [graphData] = @state.get('graphData')
    xAxis = d3.svg.axis()
      .scale(xScale)
      .tickFormat(@format)
      .orient('bottom')
      .tickValues(_.pluck(graphData, 'x'))

    @appendXAxis(xAxis)

  drawYAxis: ({yScale}) ->
    yAxis = d3.svg.axis()
      .tickFormat(d3.format('.,00f'))
      .scale(yScale)
      .orient('left')

    @appendYAxis(yAxis)
    

module.exports = Histogram