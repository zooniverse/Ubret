Spine = require('spine')
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window"

  constructor: ->
    super
    @settings = @tool.settings or new Settings {tool: @tool}

  render: =>
    @tool.render()
    @settings.render()
    @append @tool.el
    @append @settings.el
    
module.exports = ToolWindow