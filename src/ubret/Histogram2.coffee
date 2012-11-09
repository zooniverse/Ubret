
Graph = window.Ubret.Graph or require('./Graph')

class Histogram2 extends Graph
  axes: 1
  
  template:
    """
    <div class="histogram">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """
  
  constructor: (opts) ->
    console.log 'Histogram2'
    super opts
    
    @yLabel = opts.yLabel or 'Count'
  
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

  setXVar: (variable) =>
    @selectedKey = variable
    @createGraph()

  start: =>
    @createGraph()


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2