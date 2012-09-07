module.exports = """

<ul class="popup">
  <li>Subject: <%- @subject.zooniverse_id %></li>
  <li>Ra: <%- @subject.ra %>, Dec: <%- @subject.dec %></li>
  <li>Magnitude: <%- @subject.magnitude %></li>
</ul>

"""
