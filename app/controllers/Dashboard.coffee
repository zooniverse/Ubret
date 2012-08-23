Spine = require('spine')

class Dashboard extends Spine.Controller
  constructor: ->
    super
    @render()

  tools: []

  channels: []

  count: 0

  render: =>
    @html require('views/dashboard')() if @el.html

  addTool: (tool) ->
    @tools.push tool
    @channels.push tool.channel

  createTool: (className) ->
    @count += 1
    @append "<div class=\"#{className}\" id=\"#{@count}\"></div>"
    @addTool new className({el: "##{@count}"})

module.exports = Dashboard