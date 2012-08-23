require = window.require

describe 'Dashboard', ->
  Dashboard = require('controllers/Dashboard')
  BaseController = require('controllers/BaseController')
  Factory = require('lib/factories')

  beforeEach ->
    @dashboard = new Dashboard

  describe "#addTool", ->
    beforeEach ->
      @tool = sinon.stub(new BaseController)
      @dashboard.tools = new Array
      @dashboard.channels = new Array

    it 'should add a new Tool to the Dashboard', ->
      @dashboard.addTool @tool
      expect(@dashboard.tools[0]).toBe @tool

    it 'should add the Tool\'s publish channel to the list of published channels', ->
      @dashboard.addTool @tool
      expect(@dashboard.channels[0]).toBe @tool.channel

  describe "#createTool", ->
    beforeEach ->
      spyOn(BaseController, 'constructor')
      spyOn(@dashboard, 'append')
      @dashboard.createTool BaseController

    it 'should call the new Tool\'s constructor', ->
      expect(BaseController.constructor).toHaveBeenCalled()

    it 'should create a new div for the added Tool', ->
      expect(@dashboard.append).toHaveBeenCalled()
