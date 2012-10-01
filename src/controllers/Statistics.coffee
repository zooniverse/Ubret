BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Statistics extends BaseController
  events:
    'change #select-key': 'changeSelectedKey'

  constructor: ->
    super
    @currentKey = 'dec'
    @stats = []

  render: =>
    subject = @filteredData[0]

    # Ugly
    @keys = new Array
    @extractKeys subject

    @html require('../views/statistics')({@keys, @stats, @currentKey})

  start: =>
    @filterData()

    # Get data
    data = _.pluck @filteredData, @currentKey

    @stats = []

    # Check what kind of data we are looking at
    if _.any data, ((datum) -> _.isNaN parseFloat datum)
      # Data is some sort of string
    else
      # Data is numerical. Might be in strings though. Convert to floats.
      data = _.map data, (num) -> parseFloat num

    console.log 'Data: ', data

    @stats.push @getMean data
    @stats.push @getMedian data
    @stats.push @getMode data
    @stats.push @getMin data
    @stats.push @getMax data
    @stats.push @getVariance data
    @stats.push @getStandardDeviation data
    # @stats.push @getPercentile data

    @render()

  changeSelectedKey: (e) =>
    @currentKey = $(e.currentTarget).val()
    @start()

  # Statistics functions
  getMean: (data) =>
    average = _.reduce(data, ((memo, num) -> memo + num)) / data.length
    average_object = {
        'label': 'Mean',
        'value': average
      }

  getMedian: (data) =>
    data = _.sortBy data, (num) -> num

    # Check for odd length
    mid_point = data.length / 2
    if mid_point % 1
      median = (data[Math.floor mid_point] + data[Math.ceil mid_point]) / 2
    else
      median = data[data.length / 2]

    median_object = {
        'label': 'Median',
        'value': median
      }

  getMode: (data) =>
    # Currently only grabs a single number. Does not record "ties"
    data = _.groupBy data, (datum) -> datum
    keys = _.keys data

    mode_data = []
    for key in keys
      mode_data.push
        'key': key,
        'num': data[key].length

    mode = _.max mode_data, (datum) -> datum.num

    mode_object = {
        'label': 'Mode',
        'value': mode.key
      }

  getMin: (data) =>
    min_object = {
        'label': 'Minimum',
        'value': _.min data
      }

  getMax: (data) =>
    max_object = {
        'label': 'Maximum',
        'value': _.max data
      }

  getVariance: (data) =>
    data_count = data.length
    mean = @getMean data

    data = _.map data, (datum) ->
      Math.pow Math.abs(datum - mean.value), 2

    variance_data = _.reduce data, (memo, datum) ->
      memo + datum

    variance = variance_data / data_count
    variance_object = {
        'label': 'Variance',
        'value': variance
      }

  getStandardDeviation: (data) =>
    variance = (@getVariance data).value

    standard_deviation = Math.sqrt variance
    standard_deviation_object = {
        'label': 'Standard Deviation',
        'value': standard_deviation
      }

  getPercentile: (data) =>
    data = _.sortBy data, (datum) -> datum

    percentile_data = []
    # For now, use 10 chunks
    for i in [1..10]
      percent = i / 10

      # Get position of the element at the $percent position
      percentile = data[data.length * percent]
      value_object = {
          'label': (percent * 100) + 'th',
          'value': percentile
        }

      percentile_data.push value_object


    percentile_object = {
        'label': 'Percentile',
        'value': percentile_data,
        'view': 'getPercentileView'
      }

  getPercentileView: =>
    # @html require('../views/_percentile')(@)

module.exports = Statistics