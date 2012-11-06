_ = require 'underscore/underscore'

BaseTool = require 'BaseTool'

class SubjectViewer extends BaseTool

  attributes:
    currentSubject:
      name: 'currentSubject'
      default: 0
      events:
          'selector': 'click .nav .prev'
          'callback': 'prevSubject'
          'action': 'change'
        ,
          'selector': 'click .nav .next'
          'callback': 'nextSubject'
          'action': 'change'

  constructor: (opts) ->
    super
    @format = @format || d3.format(',.02f')
    @start()

  start: =>
    @render()

  render: =>
    @tool_view.html require('views/subject_viewer/base')({@getCurrentSubject(), @keys, count: @data.length, format: @format})

  getCurrentSubject: =>
    @data[@count]

  prevSubject: (count) =>
    @count -= 1
    if @count < 0
      @count = @data.length - 1
    @count

  nextSubject: (count) =>
    @count += 1
    if @count >= @data.length
      @count = 0
    @count

  # Validation
  validateCurrentSubject: (currentSubject) ->
    console.log 'noop'

  select: (itemId) =>
    subject = _.find @data, (datum) ->
      datum.zooniverse_id == itemId
    subjectIndex = _.indexOf @data, subject
    @count = subjectIndex
    @render()

    
module.exports = SubjectViewer