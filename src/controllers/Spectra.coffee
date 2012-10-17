BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Spectra extends BaseController
  
  name: "Spectra"
  
  constructor: ->
    super
    console.log 'Spectra'
    @subscribe @subChannel, @process
  
  render: =>
    console.log "index", @index
    @html require('../views/spectra')({index: @index})
  
module.exports = Spectra