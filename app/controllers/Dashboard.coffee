Spine = require('spine')
_ = require('underscore/underscore')
BindSelect = require('controllers/BindSelect')

class Dashboard extends Spine.Controller
  constructor: ->
    super
    @render()

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
    @append "<div class=\"tool\" id=\"#{@count}\"></div>"
    tool = new className({el: "##{@count}"})
    @addTool tool
    tool.append "<div class=\"bind-select\"></div>"
    bindSelect = new BindSelect { el: ".bind-select", dashboard: @, tool: tool }
    tool.append(bindSelect.html())

  bindTool: (tool, source, params='') ->
    receiverTool = _.find @tools, (tool) ->
      tool.channel = tool
    if params
      receiverTool.getDataSource source, params
    else
      receiverTool.subscribe source, tool.process
      sourceTool = _.find @tools, (tool) ->
        tool.channel == source
      receiverTool.receiveData tool.data

module.exports = Dashboard