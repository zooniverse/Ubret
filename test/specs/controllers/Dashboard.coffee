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
      #expect(BaseController.constructor).toHaveBeenCalled()

    it 'should create a new div for the added Tool', ->
      #expect(@dashboard.append).toHaveBeenCalled()

  describe "#bindTool", ->
    describe "bind to another tool", ->
      it 'should subcribe the calling tool to another\'s channel', ->
        @dashboard.tools.push new BaseController { channel: "tool-channel" }
        spyOn(@tool, 'subscribe')
        @dashboard.bindTool @tool, 'tool-channel'
        expect(@tool.subscribe).toHaveBeenCalledWith('tool-channel', @tool.process)

    describe "bind to a data source", ->
      it 'should call the tool\'s #getDataSource method', -> 
        spyOn(@tool, 'getDataSource')
        @dashboard.bindTool @tool, GalaxyZooSubject, 10
        expect(@tool.getDataSource).toHaveBeenCalledWith(GalaxyZooSubject, 10)