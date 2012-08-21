require = window.require

describe 'GalaxyZooSubject', ->
  GalaxyZooSubject = require('models/GalaxyZooSubject')
  Api = require('zooniverse/lib/api')
  Config = require('lib/config')
  
  beforeEach ->
    Api.init host: Config.apiHost

  it 'should retrieve a subject through the api', ->
    subjectFetcher = false
    GalaxyZooSubject.fetch(10).always -> subjectFetcher = true
    waitsFor -> subjectFetcher
    runs ->
      subjects = GalaxyZooSubject.all()
      console.log subjects
      expect(subjects.length).toEqual(10)