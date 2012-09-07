(function() {

  module.exports = "\n<form>\n  <label>Filter Data: <input type=\"text\" name=\"filter\" /></label>\n  <button type=\"submit\">Filter</button>\n</form>\n<ul class=\"filters\">\n<% if @filters.length: %>\n  <% for filter in @filters: %>\n    <li><%- filter.text %> <div data-id=\"<%- filter.id %>\" class=\"remove_filter\">X</div></li>\n  <% end %>\n<% end %>\n</ul>\n<table>\n  <thead>\n    <tr>\n      <% if @keys.length and @data.length: %>\n        <th>Zooniverse ID <a class=\"delete\">X</a></th>\n      <% for key in @keys: %>\n        <th><%= @prettyKey(key) %> <a class=\"delete\">X</a></th>\n      <% end %>\n      <% end %>\n    </tr>\n  </thead>\n  <tbody>\n    <% if @filteredData.length: %>\n    <% for subject in @filteredData: %>\n      <%- @requireTemplate('views/table_row', {subject, @keys}) %>\n    <% end %>\n    <% end %>\n  </tbody>\n</table>\n";

}).call(this);
