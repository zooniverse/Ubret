_ = require 'underscore/underscore'

BaseTool = require 'BaseTool'

class SubjectViewer extends BaseTool

  attributes:
    currentSubject:
      name: 'currentSubject'
      default: 0
      events: [
          'selector': 'click .nav .prev'
          'callback': 'prevSubject'
          'action': 'change'
        ,
          'selector': 'click .nav .next'
          'callback': 'nextSubject'
          'action': 'change'
        ]

  # Need to rework this. Just placeholder for now
  template:
    """
    <% if @subject: %>
      <% if @count > 1: %>
        <div class="nav">
          <a class="back">back</a>
          <a class="next">next</a>
        </div>
      <% end %>

      <% if @subject.image: %>
        <img src="<%- @subject.image %>" />
      <% end %>

      <ul>
        <li>id: <%- @subject.zooniverse_id %></li>
        <% for key, value of @keys: %>
          <li><%- key %>: <%- if typeof(@subject[value]) isnt 'string' then @format(@subject[value]) else @subject[value] %> <%- @labels[value] %></li>
        <% end %>
      </ul>
    <% end %>
    """

  constructor: (opts) ->
    super
    @format = @format || d3.format(',.02f')
    @start()

  start: =>
    @render()

  render: =>
    # Likely need to do more work here
    compiled = _.template(@template, {subject: @getCurrentSubject(), @keys, count: @data.length, format: @format})
    @tool_view.html compiled

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