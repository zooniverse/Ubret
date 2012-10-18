BaseController = require('./BaseController')
_ = require('underscore/underscore')

class SubjectViewer extends BaseController
  name: "Subject Viewer"
  constructor: ->
    super
    @format = @format || d3.format(',.02f')

  events: 
    'click .next' : 'nextSubject'
    'click .back' : 'prevSubject'

  start: =>
    @count = 0
    @render()

  labels:
    absolute_radius: 'kpc'

  render: =>
    @filterData()
    subject = @filteredData[@count]
    @publish [ {message: 'selected', item_id: subject?.zooniverse_id} ] 
    @keys = new Array
    @extractKeys subject

    keys = new Object
    keys[@prettyKey(key)] = key for key in @keys
    @html require('../views/subject_viewer')({subject, keys, count: @filteredData.length, format: @format, labels: @labels})

  nextSubject: =>
    @count += 1
    if @count >= @filteredData.length
      @count = 0
    @render()

  prevSubject: =>
    @count -= 1
    if @count < 0
      @count = @filteredData.length - 1
    @render()

  select: (itemId) =>
    subject = _.find @filteredData, (datum) ->
      datum.zooniverse_id == itemId
    subjectIndex = _.indexOf @filteredData, subject
    @count = subjectIndex
    @render()
    @publish [ {message: 'selected', item_id: itemId} ]
    
module.exports = SubjectViewer