Spine = require('spine')

class BindSelect extends Spine.Controller
  constructor: ->
    super
    @html @template(@)

  events:
    submit: 'onSubmit'

  elements: 
    'select.channel'       : 'channel'
    'select.source'        : 'source'
    'input[name="params"]' : 'params'

  template: require('views/bind_select')
    
  onSubmit: (e) =>
    e.preventDefault()
    params = @params.val()
    source = @channel.find('option:selected').val() or @source.find('option:selected').val()
    @dashboard.bindTool @tool, source, params

module.exports = BindSelect