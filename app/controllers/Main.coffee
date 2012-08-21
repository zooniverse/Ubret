Spine = require('spine')

GalaxyZooSubject = require('models/GalaxyZooSubject')

Table = require('controllers/Table')
Map   = require('controllers/Map')

class Main extends Spine.Controller
  constructor: ->
    super
    console.log 'Main'
    @append require('views/main')()
    
    GalaxyZooSubject.fetch(10).onSuccess ->
      @subjects = GalaxyZooSubject.all()
      new Table({el: "#table", subjects: @subjects}) 
      new Map({el: "#map", subjects: @subjects})
    
module.exports = Main