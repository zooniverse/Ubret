require = window.require

describe 'BaseController', ->
  BaseController = require('controllers/BaseController')
  GalaxyZooSubject = require('models/GalaxyZooSubject')
  pubSub = require('node-pubsub')

  beforeEach ->
    @baseController = new BaseController { channel: 'baseController-0' }

  it 'should have a unique channel', ->
    expect(@baseController.channel).toBeDefined()
  
  describe '#publish', ->
    it 'should publish with node-pubsub', ->
      spyOn(pubSub, 'publish')
      @baseController.publish([ { message: "The Test" } ])
      expect(pubSub.publish).toHaveBeenCalledWith(@baseController.channel, 
                                                  [ {message: "The Test"} ], 
                                                  @baseController)

  describe '#subscribe', ->
    it 'should setup the subscription', ->
      spyOn(pubSub, 'subscribe')
      callback = ->
        true
      @baseController.subscribe(@baseController.channel, callback)
      expect(pubSub.subscribe).toHaveBeenCalledWith(@baseController.channel, callback)

    it 'should trigger the callback when a message is received', ->
      callback = jasmine.createSpy()
      @baseController.subscribe(@baseController.channel, callback)
      @baseController.publish([ {message: "The Test"} ])
      expect(callback).toHaveBeenCalled()

    it 'should set off a subscribed event when it subs to a channel', ->
      spyOn(@baseController, 'trigger')
      callback = -> true
      @baseController.subscribe(@baseController.channel, callback)
      expect(@baseController.trigger).toHaveBeenCalledWith('subscribed', @baseController.channel)

  describe "#getDataSource", ->
    it 'should fetch from the DataSource with the passed params', ->
      spyOn(GalaxyZooSubject, "fetch").andCallThrough()
      @baseController.getDataSource "GalaxyZooSubject", 10
      expect(GalaxyZooSubject.fetch).toHaveBeenCalledWith(10)

  describe "#underscoresToSpaces", ->
    it 'should convert underscores to spaces', ->
      string = @baseController.underscoresToSpaces("Test_Me")
      expect(string).toBe "Test Me"

  describe "#capitalizeWords", ->
    it 'should capitalize the first letter of each word', ->
      string = @baseController.capitalizeWords("test me")
      expect(string).toBe "Test Me"

  describe "#bindbaseController", ->
    describe "bind to another baseController", ->
      it 'should subcribe the calling baseController to another\'s channel', ->
        spyOn(@baseController, 'subscribe')
        @baseController.bindTool 'baseController-channel'
        expect(@baseController.subscribe).toHaveBeenCalledWith('baseController-channel', @baseController.process)

    describe "bind to a data source", ->
      it 'should call the baseController\'s #getDataSource method', -> 
        spyOn(@baseController, 'getDataSource')
        @baseController.bindTool "GalaxyZooSubject", 10
        expect(@baseController.getDataSource).toHaveBeenCalledWith("GalaxyZooSubject", 10)
