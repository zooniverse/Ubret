(function() {

  module.exports = "\n<ul class=\"popup\">\n  <li>Subject: <%- @subject.zooniverse_id %></li>\n  <li>Ra: <%- @subject.ra %>, Dec: <%- @subject.dec %></li>\n  <li>Magnitude: <%- @subject.magnitude %></li>\n</ul>\n";

}).call(this);
