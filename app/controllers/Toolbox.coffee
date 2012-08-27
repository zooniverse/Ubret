Spine = require('spine')

class Toolbox extends Spine.Controller
  
  events: 
    'click .tool' : 'selection'
  
  constructor: ->
    console.log 'ToolBox'
    super

  render: =>
    @html require('views/toolbox')(@) if @el.html

  selection: (e) =>
    if e
      e.preventDefault()
      selected = $(e.currentTarget).attr('data-id')
    @trigger 'add-new-tool', selected
    
module.exports = Toolbox