class Histogram extends Ubret.Graph
  name: 'Histogram'
  axes: 1
  
  constructor: (selector) ->
    super selector
    @opts.axis2  = 'Count'

  start: =>
    @binFunc = if @opts.bins? then d3.layout.histogram(@opts.bins) else d3.layout.histogram()
    super

  setupData: =>
    data = _(@opts.data).pluck @opts.axis1
    @xDomain = d3.extent data
    @graphData = @binFunc data
    @yDomain = [0, d3.max(@graphData, (d) -> d.y)]

  drawData: =>
    @bars = @svg.append('g').selectAll('.bar')
      .data(@graphData)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('x', (d) => @x(d.x))
        .attr('width', @x(@graphData[1].x) - @x(@graphData[0].x))
        .attr('y', (d) => @y(d.y))
        .attr('height', (d) => @graphHeight - @y(d.y))
        .attr('fill', '#0071E5')
        .attr('stroke', '#FAFAFA')

  drawBrush: =>
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', @graphWidth)
      .attr('height', @graphHeight)
      .call(d3.svg.brush().x(@x)
      .on('brushend', @brushend))
      .selectAll('rect')
      .attr('height', @graphHeight)
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