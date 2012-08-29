_     = require('underscore/underscore')

class Dashboard extends Spine.Controller
  constructor: ->
    super

  elements:
    '.tools': 'workspace'

  tools: []

  channels: []

  sources: ["GalaxyZooSubject"]

  count: 0

  render: =>
    @html require('views/dashboard')()

  addTool: (tool) ->
    @tools.push tool
    @channels.push tool.channel
    tool.render()
    @workspace.append tool.el

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
    tool.bind "request-data-#{tool.channel}", (source) =>
      sourceTool = _.find @tools, (sTool) ->
        sTool.channel == source
      tool.receiveData sourceTool.data

module.exports = Dashboard