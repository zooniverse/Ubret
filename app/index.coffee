require('lib/setup')

Spine   = require('spine')
Api     = require 'zooniverse/lib/api'
Config  = require 'lib/config'

Main  = require('controllers/Main')

class App extends Spine.Controller
  constructor: ->
    super
    Api.init host: Config.apiHost
    new Main({el: "body"})

module.exports = App