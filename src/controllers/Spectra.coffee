BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Spectra extends BaseController
  
  name: "Spectra"
  
  constructor: ->
    super
    console.log 'Spectra'
    @subscribe @subChannel, @process
    @bind 'data-received', @plot
  
  render: =>
    console.log "index", @index
    @html require('../views/spectra')({index: @index})
  
  plot: =>
    console.log 'wavelength versus flux', @data[0].wavelengths, @data[0].flux
    
  
module.exports = Spectra