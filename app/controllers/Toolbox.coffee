Spine = require('spine')

class Toolbox extends Spine.Controller
  constructor: ->
    super
    @render()

  events: 
    'click .tool' : 'selection'

  render: =>
    console.log @tools
    @html require('views/toolbox')(@) if @el.html

  selection: (e) =>
    if e
      e.preventDefault()
      selected = $(e.currentTarget).attr('data-id')
    @trigger 'add-new-tool', selected
    
module.exports = Toolbox