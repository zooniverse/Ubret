BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Scatterplot extends BaseController
  constructor: ->
    super
    
    @xAxisKey = 'ra'
    @yAxisKey = 'dec'
    @createGraph()

  name: "Scatterplot"

  keys: []

  createGraph: ->
    @graph = nv.models.scatterChart()
                      .showLegend(false)
                      .tooltipXContent(null)
                      .tooltipYContent(null)
                      .tooltipContent(@tooltipDisplay)
                      .color(d3.scale.category10().range())
    @graph.scatter.id(@channel)

  tooltipDisplay: (series, x, y, object, chart) =>
    point = object.point
    datum = _.find @data, (datum) ->
      datum.zooniverse_id == point.zooniverse_id
    @publish [ {message: 'selected', item_id: point.zooniverse_id} ]
    xAxis = @xAxisKey
    yAxis = @yAxisKey
    require('../views/scatterplot_tooltip')({datum, xAxis, yAxis})

  start: =>
    @filterData()
    @addData() 
    @addFieldsToAxes()
    @addAxis()

  addFieldsToAxes: ->
    @extractKeys @data[0]
    options = ""
    for key in @keys
      options += "<option value='#{key}'>#{@prettyKey(key)}</option>"
    
    @el.find('.axis_controls').html("
      <select class='x-axis'>
        #{options}
      </select>
      <select class='y-axis'>
        #{options}
      </select>
    ")
    
    $("##{@channel} .x-axis").change (e) =>
      @xAxisKey = e.currentTarget.value
      @graph.xAxis
        .axisLabel(@xAxisKey)
      @addData()
      
    $("##{@channel} .y-axis").change (e) =>
      @yAxisKey = e.currentTarget.value
      @graph.yAxis
        .axisLabel(@yAxisKey)
      @addData()

  addData: (options) ->
    options =
      size: 1
      shape: 'circle'

    @series = [
      key: "Group"
      values: []
    ]

    if @filteredData
      for subject in @filteredData
        @series[0].values.push
          x: subject[@xAxisKey]
          y: subject[@yAxisKey] 
          size: options.size 
          shape: options.shape
          zooniverse_id: subject.zooniverse_id

    d3.select("##{@channel} svg")
      .datum(@series)
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
    @html require('../views/scatterplot')(@)

  select: (itemId) =>
    d3.select(@point).classed("hover", false)
    item = _.find @series[0].values, (value) ->
      value.zooniverse_id == itemId
    itemIndex = _.indexOf @series[0].values, item
    @point = ".nv-chart-#{@channel} .nv-series-0 .nv-point-#{itemIndex}"
    d3.select(@point).classed("hover", true)
    @publish [ {message: "selected", item_id: itemId} ]
      
module.exports = Scatterplot