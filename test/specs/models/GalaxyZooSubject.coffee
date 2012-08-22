require = window.require

describe 'GalaxyZooSubject', ->
  Factory = require './lib/factories'

  beforeEach ->
    @galaxyZooSubject = Factory.build('galaxyZooSubject')

  it 'should be instantiable', ->
    expect(@galaxyZooSubject).not.toBeNull()
