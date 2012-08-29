Spine = require('spine')
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window"

  events: 
    'click .close-window'   : 'release'
    'click .toggle-settings': 'toggleSettings'

  constructor: ->
    super
    @settings = @tool.settings or new Settings {tool: @tool}

  render: =>
    @tool.render()
    @settings.render()
    @append @windowControls()
    @append @tool.el
    @append @settings.el

  windowControls: ->
    """
    <div class="window-controls">
      <ul>
        <li><a class="close-window">X</a></li>
        <li>#{@tool.channel}</li>
        <li><a class="toggle-settings">settings</a></li>
      </ul>
    </div>
    """

  toggleSettings: (e) =>
    e.preventDefault()
    console.log 'here'
    @$el.toggleClass 'settings-active'

module.exports = ToolWindow