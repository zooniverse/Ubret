require = window.require

describe 'LookUpSubject', ->
  LookUpSubject = require('models/LookupSubject')

  describe '#fetch', ->
    it 'should make jsonp call'
    