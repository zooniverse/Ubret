(function() {

  module.exports = "\n<tr class='subject' data-id=<%= @subject.zooniverse_id %>>\n  <td><%- @subject.zooniverse_id %></td>\n  <% if @keys.length: %>\n  <% for key in @keys: %>\n  <td><%- @subject[key] %></td>\n  <% end %>\n  <% end %>\n</tr>\n";

}).call(this);
