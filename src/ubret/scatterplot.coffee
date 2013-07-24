class Scatterplot extends Ubret.Graph
  name: 'Scatterplot'
  brushEnabled: true
  
  constructor: ->
    @events['selection'] = @drawData
    super 
  
  graphData: =>
    data = @preparedData()
    return if _.isEmpty(data) or !@opts.axis1 or !@opts.axis2
    _.chain(data).shuffle().take(300)
      .map((d) => _(d).pick(@opts.axis1, @opts.axis2, 'uid'))
      .value()

  drawData: =>
    data = @graphData()
    return if _.isUndefined(data)
    xScale = @x()
    yScale = @y()
    @points.remove() if @points?

    @points = @svg.append('g').selectAll('circle')
      .data(data)

    @points.enter().append('circle')
      .attr('class', 'dot')
      .attr('r', 2)
      .attr('cx', (d) => xScale(d[@opts.axis1]))
      .attr('cy', (d) => yScale(d[@opts.axis2]))
      .attr('fill', (d) => 
        return @opts.color if _.isEmpty(@opts.selectedIds)
        if d.uid in @opts.selectedIds
          @opts.selectedColor
        else
          @opts.color)

    @drawBrush() if @brushEnabled
  
  drawBrush: =>
    @brush.remove() unless !@brush
    @brush = @svg.append('g')
      .attr('class', 'brush')
      .attr('width', @graphWidth())
      .attr('height', @graphHeight())
      .call(d3.svg.brush().x(@x()).y(@y())
      .on('brushend', @brushend))
      .attr('height', @graphHeight())
      .attr('opacity', 0.5)
      .attr('fill', '#CD3E20')
  
  brushend: =>
    d = d3.event.target.extent()
    x = d.map( (x) -> return x[0])
    y = d.map( (x) -> return x[1])
    top = _.chain(@graphData())
      .filter( (d) =>
        (d[@opts.axis1] > x[0]) and (d[@opts.axis1] < x[1]))
      .filter( (d) =>
        (d[@opts.axis2] > y[0]) and (d[@opts.axis2] < y[1]))
      .pluck('uid')
      .value()
    @selectIds top
  
window.Ubret.Scatterplot = Scatterplot