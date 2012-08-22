GalaxyZooSubject = require('models/GalaxyZooSubject')
Factory = require 'rosie'

Factory.define('galaxyZooSubject', GalaxyZooSubject)
  .sequence('id')
  .attr('coords', ->
    [Math.random()*100, Math.random()*100] 
  )
  .atrr('metadata', ->
    return {
      magnitude: ((Math.random()*20)+10)
      distance: (Math.random()*10000)
    }
  )
  .atrr('location', { standard: "image/120341241.jpg", thumbnail: "image/120341241-thumb.jpg", inverted: "image/120341241-invert.jpg", fitts: "iamge/120341241.fitts" })

module.export = Factory