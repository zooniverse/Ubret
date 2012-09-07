(function() {

  module.exports = "\n<ul>\n  <li>id: <%- @datum.zooniverse_id %></li>\n  <li><%- @xAxis %>: <%- @datum[@xAxis] %></li>\n  <li><%- @yAxis %>: <%- @datum[@yAxis] %></li>\n</ul>\n";

}).call(this);
