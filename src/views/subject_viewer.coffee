module.exports = """

<% if @subject: %>
<ul>
  <li>id: <%- @subject.zooniverse_id %></li>
  <% if @subject.image.src: %>
  <li><img src="<%- @subject.image.src %>" /></li>
  <% end %>
  <% for key in @keys: %>
  <li><%- key %>: <%- @subject[key] %></li>
  <% end %>
</ul>
<% end %>
<a class="next">next</a>
<a class="back">back</a>

"""
