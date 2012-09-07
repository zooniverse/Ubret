(function() {

  module.exports = "\n<% if @subject: %>\n<ul>\n  <li>id: <%- @subject.zooniverse_id %></li>\n  <% if @subject.image.src: %>\n  <li><img src=\"<%- @subject.image.src %>\" /></li>\n  <% end %>\n  <% for key in @keys: %>\n  <li><%- key %>: <%- @subject[key] %></li>\n  <% end %>\n</ul>\n<% end %>\n<a class=\"next\">next</a>\n<a class=\"back\">back</a>\n";

}).call(this);
