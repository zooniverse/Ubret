_ = require 'underscore/underscore'

BaseTool = require 'BaseTool'

class SubjectViewer extends BaseTool

  constructor: (@data) ->
    super
    @format = @format || d3.format(',.02f')

    @tool_view.find('.nav .prev').on 'click', @prevSubject
    @tool_view.find('.nav .next').on 'click', @nextSubject

    @start()

  start: =>
    @count = 0
    @render()

  render: =>
    @tool_view.html require('views/subject_viewer/base')({@currentSubject(), @keys, count: @data.length, format: @format})

  currentSubject: =>
    @data[@count]

  nextSubject: =>
    @count += 1
    if @count >= @data.length
      @count = 0
    @render()

  prevSubject: =>
    @count -= 1
    if @count < 0
      @count = @data.length - 1
    @render()

  select: (itemId) =>
    subject = _.find @filteredData, (datum) ->
      datum.zooniverse_id == itemId
    subjectIndex = _.indexOf @filteredData, subject
    @count = subjectIndex
    @render()

    
module.exports = SubjectViewer