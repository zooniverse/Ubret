require = window.require

describe 'Dashboard', ->
  Dashboard = require('controllers/Dashboard')
  BaseController = require('controllers/BaseController')
  GalaxyZooSubject = require('models/GalaxyZooSubject')
  Factory = require('lib/factories')

  beforeEach ->
    @dashboard = new Dashboard
    @tool = sinon.stub(new BaseController)

  describe "#addTool", ->
    beforeEach ->
      spyOn(@dashboard, 'createWindow')
      @dashboard.tools = new Array
      @dashboard.channels = new Array
      @dashboard.addTool @tool

    it 'should add a new Tool to the Dashboard', ->
      expect(@dashboard.tools[0]).toBe @tool

    it 'should add the Tool\'s publish channel to the list of published channels', ->
      expect(@dashboard.channels[0]).toBe @tool.channel

    it 'should call #createWindow', ->
      expect(@dashboard.createWindow).toHaveBeenCalled()

  describe "#createTool", ->
    beforeEach ->
      #spyOn(BaseController, 'constructor')
      #spyOn(@dashboard, 'append')
      #@dashboard.createTool BaseController

    it 'should call the new Tool\'s constructor', ->
      #expect(BaseController.constructor).toHaveBeenCalled()

    it 'should create a new div for the added Tool', ->
      #expect(@dashboard.append).toHaveBeenCalled()
