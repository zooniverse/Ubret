
Graph = window.Ubret.Graph or require('./Graph')

class Scatter2D extends Graph
  axes: 2
  
  template:
    """
    <div class="histogram">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """
  
  constructor: (opts) ->
    console.log 'Scatter2D'
    super opts
  
  draw: =>
    console.log 'Scatter2D draw'
    
    # Get data from crossfilter object
    data = @dimensions[@axis1].top(Infinity)
    data = _.map(data, (d) => _.pick(d, d[@axis1], d[@axis2]))
    
    xDomain = d3.extent(data, (d) => d[@axis1])
    yDomain = d3.extent(data, (d) => d[@axis2])
    
    console.log xDomain, yDomain
    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Scatter2D
else
  window.Ubret['Scatter2D'] = Scatter2D