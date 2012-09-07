module.exports = """

<tr class='subject' data-id=<%= @subject.zooniverse_id %>>
  <td><%- @subject.zooniverse_id %></td>
  <% if @keys.length: %>
  <% for key in @keys: %>
  <td><%- @subject[key] %></td>
  <% end %>
  <% end %>
</tr>

"""
