class Histogram extends Ubret.Graph
  name: 'Histogram'
  
  constructor: (selector) ->
    super selector
    @opts.axis2  = 'Count'

  graphData: =>
    return if _.isEmpty(@opts.data) or !@opts.axis1
    @binFunc = if @opts.bins? 
      d3.layout.histogram().bins(parseInt(@opts.bins)) 
    else 
      d3.layout.histogram()
    data = _(@opts.data).pluck @opts.axis1
    @binFunc data

  yDomain: =>
    data = @graphData()
    return if _.isUndefined(data)
    [0, d3.max(data, (d) -> d.y)]

  drawData: =>
    data = @graphData()
    return if _.isUndefined(data)
    @svg.selectAll('g.bar').remove()

    bars = @svg.selectAll('g.bar')
      .data(data)

    bars.enter().append('g')
      .attr("class", 'bar')
      .append("rect")

    bars.selectAll("rect")
        .attr('width', @x()(data[1].x) - @x()(data[0].x))
        .attr('height', (d) => @graphHeight() - @y()(d.y))
        .attr('x', (d) => @x()(d.x))
        .attr('y', (d) => @y()(d.y))
        .attr('fill', @opts.color)
        .attr('stroke', '#FAFAFA')

    @drawBrush()

  drawBrush: =>
    @brush.remove() if @brush
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', @graphWidth())
      .attr('height', @graphHeight())
      .call(d3.svg.brush().x(@x())
      .on('brushend', @brushend))
      .selectAll('rect')
      .attr('height', @graphHeight())
      .attr('opacity', 0.5)
      .attr('fill', '#CD3E20')

  brushend: =>
    x = d3.event.target.extent()
    top = _.chain(@opts.data)
      .filter( (d) =>
        (d[@opts.axis1] > x[0]) and (d[@opts.axis1] < x[1]))
      .pluck('uid')
      .value()
    @selectIds top
    
window.Ubret.Histogram = Histogram