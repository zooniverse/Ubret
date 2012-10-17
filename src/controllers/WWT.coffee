BaseController = require('./BaseController')
_ = require('underscore/underscore')

class WWT extends BaseController
  
  name: "WWT"
  
  constructor: ->
    super
    console.log 'WWT'
    @subscribe @subChannel, @process
  
  render: =>
    @html require('../views/wwt')({index: @index})
  
module.exports = WWT