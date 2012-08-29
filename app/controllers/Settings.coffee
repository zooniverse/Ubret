Spine = require('spine')

class Settings extends Spine.Controller
  constructor: ->
    super

  events:
    submit: 'onSubmit'

  elements: 
    'select.channel'       : 'channel'
    'select.source'        : 'source'
    'input[name="params"]' : 'params'

  className: "settings"

  template: require('views/settings')

  render: =>
    @html @template(@)
    
  onSubmit: (e) =>
    e.preventDefault()
    params = @params.val()
    source = @channel.find('option:selected').val() or @source.find('option:selected').val()
    @$el.parent().toggleClass 'settings-active'
    @tool.bindTool source, params

module.exports = Settings