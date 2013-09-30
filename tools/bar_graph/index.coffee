class BarGraph extends Ubret.Graph
  name: "Bar Graph"

  constructor: ->
    super
    @opts.axis2 = 'Count'

  graphData: =>
    return if _.isEmpty(@preparedData()) or !@opts.axis1
    index = 0
    _.chain(@preparedData()).pluck(@opts.axis1)
      .flatten().countBy((d) -> d).pairs()
      .map((d) -> 
        d.push index
        index += 1
        d).value()

  yDomain: =>
    data = @graphData()
    return if _.isUndefined(data)
    [0, d3.max(data, (d) -> d[1])]

  xDomain: => 
    data = @graphData()
    return if _.isUndefined(data)
    [0, data.length]

  drawData: =>
    data = @graphData()
    return if _.isUndefined(data)
    @svg.selectAll('g.bar').remove()
    @svg.selectAll('g.label').remove()

    bars = @svg.selectAll('g.bar').data(data)

    bars.enter().append('g')
      .attr('class', 'bar')
      .append('rect')

    bars.selectAll('rect')
      .attr('width', Math.floor(@graphWidth() / data.length))
      .attr('height', (d) => @graphHeight() - @y()(d[1]))
      .attr('x', (d) => @x()(d[2]))
      .attr('y', (d) => @y()(d[1]))
      .attr('fill', @opts.color)
      .attr('stroke', '#FAFAFA')

    labels = @svg.selectAll('g.label').data(data)

    labels.enter().append('g')
      .attr('class', 'label')
      .append('text')

    labels.selectAll('text')
      .attr('x', (d) => @x()(d[2] + .5))
      .attr('y', (d) => 
        if d[2] % 2 is 0
          @graphHeight() + 27
        else
          @graphHeight() + 12)
      .attr('text-anchor', 'middle')
      .text((d) -> d[0])

  drawAxis2: =>
    return unless @opts.axis1?
    super

  drawAxis1: =>
    return unless @opts.axis1? and not _.isEmpty(@preparedData())
    xAxis = d3.svg.axis()
      .scale(@x())
      .orient('bottom')
      .ticks(0)

    axis = @svg.select('g.x').remove()
    axis = @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{@graphHeight()})")
      .call(xAxis)

    @labelAxis1(axis)
    

window.Ubret.BarGraph = BarGraph
