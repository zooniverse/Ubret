require = window.require
sinon = require 'sinon'
console.log sinon
Factory = require '../factories'

describe 'GalaxyZooSubject', ->
  beforeEach ->
    @galaxyZooSubject = Factory.build('galaxyZooSubject')

  it 'should be instantiable', ->
    expect(@galaxyZooSubject).not.toBeNull()
