class Scatterplot extends Ubret.Graph
  name: 'Scatterplot'
  axes: 2
  
  constructor: (selector) ->
    super selector 
  
  setupData: =>
    # Create Dimensions for Axes
    # Get data from crossfilter object
    @graphData = _.map(@opts.data, (d) => _(d).pick(@opts.axis1, @opts.axis2, 'uid'))
    @xDomain = d3.extent(@graphData, (d) => d[@opts.axis1])
    @yDomain = d3.extent(@graphData, (d) => d[@opts.axis2])

  drawData: =>
    @points = @svg.append('g').selectAll('circle')
        .data(@graphData)
      .enter().append('circle')
        .attr('class', 'dot')
        .attr('r', 1.5)
        .attr('cx', (d) => @x(d[@opts.axis1]))
        .attr('cy', (d) => @y(d[@opts.axis2]))
        .attr('fill', (d) => 
          if d.uid in @opts.selectedIds
            return @opts.selectedColor
          else
            return @opts.color
        )
        .on('mouseover', @displayTooltip)
        .on('mouseout', @removeTooltip)
  
  drawBrush: =>
    @svg.append('g')
      .attr('class', 'brush')
      .attr('width', @graphWidth)
      .attr('height', @graphHeight)
      .attr('height', @graphHeight)
      .attr('opacity', 0.5)
      .attr('fill', '#CD3E20')
      .call(d3.svg.brush().x(@x).y(@y)
      .on('brushend', @brushend))
  
  brushend: =>
    d = d3.event.target.extent()
    x = d.map( (x) -> return x[0])
    y = d.map( (x) -> return x[1])
    console.log x, y
    
    # Select all items within the range
    # TODO: Pass these data down the chain
    top = _.chain(@graphData)
      .filter( (d) =>
        (d[@opts.axis1] > x[0]) and (d[@opts.axis1] < x[1]))
      .filter( (d) =>
        (d[@opts.axis2] > y[0]) and (d[@opts.axis2] < y[1]))
      .pluck('uid')
      .value()
    console.log top
    @selectIds top
  
window.Ubret.Scatterplot = Scatterplot