BaseTool = window.Ubret.BaseTool or require('./base_tool')

class SubjectViewer extends BaseTool

  template:
    """
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
    @start()

  start: =>
    data = @dimensions.id.top(Infinity)
    @render()

  render: =>
    if @selectedElements
      subject = _.find @dimensions.id.top(Infinity), (record) =>
        record.id == @selectedElements[0]
    else
      subject = @dimensions.id.top(Infinity)[0]

    compiled = _.template @template, { subject: subject, keys: @keys }
    @el.html compiled

    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = SubjectViewer
else
  window.Ubret['SubjectViewer'] = SubjectViewer
