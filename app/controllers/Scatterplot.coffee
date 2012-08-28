BaseController = require('controllers/BaseController')
_ = require('underscore/underscore')

class Scatterplot extends BaseController
  constructor: ->
    super
    @xAxisKey = 'ra'
    @yAxisKey = 'dec'
    @createGraph()

  name: "Scatterplot"

  template: require('views/scatterplot')

  createGraph: ->
    @graph = nv.models.scatterChart()
                      .showLegend(false)
                      .tooltipXContent(null)
                      .tooltipYContent(null)
                      .tooltipContent( (series, x, y, object, chart) =>
                        point = object.point
                        datum = _.find @data, (datum) ->
                          datum.zooniverse_id == point.zooniverse_id
                        @publish [ {message: 'selected', item_id: point.zooniverse_id} ]
                        require('views/scatterplot_tooltip')({datum})
                      )
                      .color(d3.scale.category10().range())

  receiveData: (data) =>
    super
    @initGraph()

  getDataSource: (source, params) ->
    super.always =>
      @initGraph()

  initGraph: =>
    @addAxis()
    @addData() 

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
          zooniverse_id: subject.zooniverse_id

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
    super
    @append @template(@)
    
module.exports = Scatterplot