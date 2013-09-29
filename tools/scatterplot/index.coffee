Graph = require('tools/graph')

class Scatterplot extends Graph
  name: 'Scatterplot'
  className: 'scatterplot'
  brushEnabled: true

  settings: [require('tools/settings/x_axis_key'),
             require('tools/settings/x_axis_min_max'),
             require('tools/settings/y_axis_key'),
             require('tools/settings/y_axis_min_max')]

  constructor: ->
    super
  
  drawGraph: ({data, xAxis, yAxis, xScale, yScale, selection, xMin, xMax, yMin, yMax, height, width}) =>
    data = data.project('uid', xAxis, yAxis)
    data = data.filter((i) => i[xAxis] >= xMin) if xMin
    data = data.filter((i) => i[xAxis] <= xMax) if xMax
    data = data.filter((i) => i[yAxis] >= yMin) if yMin
    data = data.filter((i) => i[yAxis] <= yMax) if yMax
    data = data.toArray()

    point = @chart.selectAll('circle')
      .data(data, (d) -> d.uid)

    point.enter().append('circle')
      .attr('class', 'dot')
      .attr('r', 2)

    point.attr('class', (d) -> if d.uid in (selection || []) then 'selected' else '')
      .attr('cx', (d) -> xScale(d[xAxis]))
      .attr('cy', (d) -> console.log(d) if _.isNaN(yScale(d[yAxis])); yScale(d[yAxis]))

    point.exit().remove()

    @drawBrush(xScale, yScale, height, width) if @brushEnabled
  
  drawBrush: (x, y, height, width) =>
    @brush.remove() unless !@brush
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', width - @marginLeft)
      .attr('height', height - @marginTop)
      .attr('transform', "translate(#{@marginLeft}, 0)")
      .call(d3.svg.brush().x(x).y(y).on('brushend', @brushend))
        .attr('height', height - @marginTop)
        .attr('opacity', 0.5)
        .attr('fill', '#CD3E20')
  
  brushend: =>
    [data, xAxis, yAxis] = @state.get('data', 'xAxis', 'yAxis')
    d = d3.event.target.extent()
    x = d.map( (x) -> return x[0])
    y = d.map( (x) -> return x[1])
    selection = data.project('uid')
      .filter( (d) => (d[xAxis] > x[0]) and (d[xAxis] < x[1]))
      .filter( (d) => (d[yAxis] > y[0]) and (d[yAxis] < y[1]))
    @state.set('selection', _.pluck(selection.toArray(), 'uid'))
 
module.exports = Scatterplot