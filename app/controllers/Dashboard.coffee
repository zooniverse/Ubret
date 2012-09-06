_      = require('underscore/underscore')
ToolWindow = require('controllers/ToolWindow')

class Dashboard extends Spine.Controller
  constructor: ->
    super

  elements:
    '.tools': 'workspace'

  tools: []
  channels: []
  sources: ["GalaxyZooSubject", "SkyServerSubject"]
  count: 0

  render: =>
    @html require('views/dashboard')()

  addTool: (tool) ->
    @tools.push tool
    @channels.push tool.channel
    @createWindow(tool)

  createTool: (className) ->
    @count += 1
    name = className.name.toLowerCase()

    tool = new className
      className: "#{name} tool" 
      index: @count
      channel: "#{name}-#{@count}"
      sources: @sources
      channels: @channels

    @addTool tool
    tool.bind "subscribed", (source) =>
      sourceTool = _.find @tools, (sTool) ->
        sTool.channel == source
      tool.receiveData sourceTool.filteredData

  createWindow: (tool) ->
    window = new ToolWindow {tool: tool}
    window.render()
    window.el.toggleClass 'settings-active'
    @workspace.append window.el
    window.bind 'remove-tool', @removeTool

  removeTool: (tool) =>
    @tools = _.without @tools, tool
    @channels = _.without @channels, tool.channel

module.exports = Dashboard