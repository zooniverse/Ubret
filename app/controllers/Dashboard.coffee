Spine = require('spine')
_ = require('underscore/underscore')
BindSelect = require('controllers/BindSelect')

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
    @html require('views/dashboard')() if @el.html

  addTool: (tool) ->
    @tools.push tool
    @channels.push tool.channel

  createTool: (className) ->
    @count += 1
    name = className.name.toLowerCase()
    @workspace.append "<div class='#{name}' id=\"#{@count}\"></div>" if typeof(@workspace) == 'object'
    tool = new className({el: "##{@count}", index: @count, channel: "#{name}-#{@count}"})
    @addTool tool
    bindSelect = new BindSelect { el: "##{@count} .bind-select", dashboard: @, tool: tool } if typeof(@workspace) == 'object'

  bindTool: (tool, source, params='') ->
    if params
      tool.getDataSource source, params
    else
      tool.subscribe source, tool.process
      sourceTool = _.find @tools, (sTool) ->
        sTool.channel == source
      tool.receiveData sourceTool.data

module.exports = Dashboard