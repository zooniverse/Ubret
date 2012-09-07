module.exports = """

<form>
  <label>Filter Data: <input type="text" name="filter" /></label>
  <button type="submit">Filter</button>
</form>
<ul class="filters">
<% if @filters.length: %>
  <% for filter in @filters: %>
    <li><%- filter.text %> <div data-id="<%- filter.id %>" class="remove_filter">X</div></li>
  <% end %>
<% end %>
</ul>
<table>
  <thead>
    <tr>
      <% if @keys.length and @data.length: %>
        <th>Zooniverse ID <a class="delete">X</a></th>
      <% for key in @keys: %>
        <th><%= @prettyKey(key) %> <a class="delete">X</a></th>
      <% end %>
      <% end %>
    </tr>
  </thead>
  <tbody>
    <% if @filteredData.length: %>
    <% for subject in @filteredData: %>
      <%- @requireTemplate('views/table_row', {subject, @keys}) %>
    <% end %>
    <% end %>
  </tbody>
</table>

"""