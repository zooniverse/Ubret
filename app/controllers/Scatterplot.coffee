BaseController = require('controllers/BaseController')

class Scatterplot extends BaseController
  constructor: ->
    super
    @xAxisKey = 'ra'
    @yAxisKey = 'dec'
    @createGraph()
    @render()

  template: require('views/scatterplot')

  createGraph: ->
    @graph = nv.models.scatterChart()
                      .color(d3.scale.category10().range())

  addData: (options) ->
    options =
      size: 1
      shape: 'circle'

    series = [
      key: "Group"
      values: []
    ]
    if @data
      for subject in @data
        series[0].values.push
          x: subject[@xAxisKey]
          y: subject[@yAxisKey] 
          size: options.size 
          shape: options.shape

    d3.select("##{@channel} svg")
      .datum(series)
      .transition().duration(500)
      .call(@graph)

    nv.utils.windowResize(@graph.update)

  addAxis: (options) ->
    options =
      xAxisFormat: '10f'
      yAxisFormat: '10f'

    @graph.xAxis
      .axisLabel(@xAxisKey)
      .tickFormat d3.format(options.xAxisFormat)

    @graph.yAxis
      .axisLabel(@yAxisKey)
      .tickFormat d3.format(options.yAxisFormat)

  render: =>
    @html @template(@)
    @addAxis()
    @addData() 
    
    
    
module.exports = Scatterplot