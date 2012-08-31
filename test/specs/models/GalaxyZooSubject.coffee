require = window.require

describe 'GalaxyZooSubject', ->
  GalaxyZooSubject = require('models/GalaxyZooSubject')

  beforeEach ->
    @galazyZooSubject = GalaxyZooSubject.create()

  it 'should be instantiable', ->
    expect(@galaxyZooSubject).not.toBeNull()
