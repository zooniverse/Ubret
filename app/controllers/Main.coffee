Spine = require('spine')

GalaxyZooSubject = require('models/GalaxyZooSubject')

Dashboard   = require('controllers/Dashboard')
Toolbox     = require('controllers/Toolbox')
Table       = require('controllers/Table')
Map         = require('controllers/Map')
Scatterplot = require('controllers/Scatterplot')

class Main extends Spine.Controller
  constructor: ->
    super
    console.log 'Main'
    @append require('views/main')()
    
    # GalaxyZooSubject.fetch().onSuccess ->
    #   
    #   # Grab data from Ouroboros
    #   subjects = GalaxyZooSubject.all()
      
    # Create dashboard
    @dashboard = new Dashboard({el: ".dashboard"})
    @dashboard.render()
    
    @toolbox = new Toolbox( {el: ".toolbox", tools: [ {name: "Scatterplot", desc: "Plots things scatteredly" }, {name: "Map", desc: "Maps Things"}, {name: "Table", desc: "Tables Things"} ]} )
    @toolbox.render()
    @toolbox.bind 'add-new-tool', @addTool

  addTool: (toolName) =>
    switch toolName
      when "Map" then @dashboard.createTool Map
      when "Table" then @dashboard.createTool Table
      when "Scatterplot" then @dashboard.createTool Scatterplot


module.exports = Main