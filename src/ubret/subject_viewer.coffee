BaseTool = window.Ubret.BaseTool or require('./base_tool')

class SubjectViewer extends BaseTool
  name: 'Subject Viewer'
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

  start: =>
    data = @dimensions.id.top(Infinity)
    unless @selectedElements
      subject = data[0]
    else
      subject = _.find data, (record) =>
        record.id == @selectedElements[0]

    compiled = _.template @template, { subject: subject, keys: @keys }
    @el.html compiled

    
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = SubjectViewer
else
  window.Ubret['SubjectViewer'] = SubjectViewer