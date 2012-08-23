require = window.require

describe 'Toolbox', ->
  Toolbox = require('controllers/Toolbox')

  beforeEach ->
    @toolbox = new Toolbox { tools: [
                               name: 'TestTool'
                               desc: 'Does Something'
                             , 
                               name: 'TestTool2'
                               desc: 'Does something else'
                            ]}

  describe "#selection", ->
    it 'should trigger an event on click', ->
      spyOn(@toolbox, "trigger")
      @toolbox.selection()
      expect(@toolbox.trigger).toHaveBeenCalled()