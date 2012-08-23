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
    name = className.name.toLowerCase()
    @append "<div class='#{name}' id=\"#{@count}\"></div>"
    @addTool new className({el: "##{@count}", index: @count})
    @count += 1

module.exports = Dashboard