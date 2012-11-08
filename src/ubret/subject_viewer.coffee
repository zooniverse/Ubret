try
  BaseTool = require './base_tool'
catch error
  BaseTool = window.Ubret.BaseTool

class SubjectViewer extends BaseTool

  template:
    """
    <% if(subject.image) { %>
      <img src="<%- subject.image %>" />
    <% } %>

    <ul>
      <% for(i = 0; i < keys.length; i++) { %>
        <li>
          <%- keys[i] %>: <%- subject[keys[i]] %>
        </li>
      <% } %>
    </ul>
    """

  constructor: (opts) ->
    super
    @count = 0
    @start()

  start: =>
    if @selectedElement
      for datum, i in @data
        if @selectedElement is datum.id
          @count = i
    @render()

  render: =>
    compiled = _.template @template, { subject: @data[@count], keys: @keys }
    @el.html compiled

  prevSubject: =>
    @count -= 1
    if @count < 0
      @count = @data.length - 1
    @selectElementCb @data[@count].id

  nextSubject: =>
    @count += 1
    if @count >= @data.length
      @count = 0
    @selectElementCb @data[@count].id

    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = SubjectViewer
else
  window.Ubret['SubjectViewer'] = SubjectViewer