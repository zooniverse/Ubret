require = window.require

describe 'BaseController', ->
  BaseController = require('controllers/BaseController')
  pubSub = require('node-pubsub')

  beforeEach ->
    @baseController = new BaseController

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