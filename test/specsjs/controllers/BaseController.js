(function() {
  var require;

  require = window.require;

  describe('BaseController', function() {
    var BaseController, GalaxyZooSubject, pubSub;
    BaseController = require('controllers/BaseController');
    GalaxyZooSubject = require('models/GalaxyZooSubject');
    pubSub = require('node-pubsub');
    beforeEach(function() {
      return this.baseController = new BaseController({
        channel: 'baseController-0'
      });
    });
    it('should have a unique channel', function() {
      return expect(this.baseController.channel).toBeDefined();
    });
    describe('#publish', function() {
      return it('should publish with node-pubsub', function() {
        spyOn(pubSub, 'publish');
        this.baseController.publish([
          {
            message: "The Test"
          }
        ]);
        return expect(pubSub.publish).toHaveBeenCalledWith(this.baseController.channel, [
          {
            message: "The Test"
          }
        ], this.baseController);
      });
    });
    describe('#subscribe', function() {
      it('should setup the subscription', function() {
        var callback;
        spyOn(pubSub, 'subscribe');
        callback = function() {
          return true;
        };
        this.baseController.subscribe(this.baseController.channel, callback);
        return expect(pubSub.subscribe).toHaveBeenCalledWith(this.baseController.channel, callback);
      });
      it('should trigger the callback when a message is received', function() {
        var callback;
        callback = jasmine.createSpy();
        this.baseController.subscribe(this.baseController.channel, callback);
        this.baseController.publish([
          {
            message: "The Test"
          }
        ]);
        return expect(callback).toHaveBeenCalled();
      });
      return it('should set off a subscribed event when it subs to a channel', function() {
        var callback;
        spyOn(this.baseController, 'trigger');
        callback = function() {
          return true;
        };
        this.baseController.subscribe(this.baseController.channel, callback);
        return expect(this.baseController.trigger).toHaveBeenCalledWith('subscribed', this.baseController.channel);
      });
    });
    describe("#getDataSource", function() {
      return it('should fetch from the DataSource with the passed params', function() {
        spyOn(GalaxyZooSubject, "fetch").andCallThrough();
        this.baseController.getDataSource("GalaxyZooSubject", 10);
        return expect(GalaxyZooSubject.fetch).toHaveBeenCalledWith(10);
      });
    });
    describe("#underscoresToSpaces", function() {
      it('should convert underscores to spaces', function() {
        var string;
        string = this.baseController.underscoresToSpaces("Test_Me");
        return expect(string).toBe("Test Me");
      });
      return it('should convert multiple underscores to spaces', function() {
        var string;
        string = this.baseController.underscoresToSpaces("Test_Me_Out");
        return expect(string).toBe("Test Me Out");
      });
    });
    describe("#capitalizeWords", function() {
      return it('should capitalize the first letter of each word', function() {
        var string;
        string = this.baseController.capitalizeWords("test me");
        return expect(string).toBe("Test Me");
      });
    });
    return describe("#bindbaseController", function() {
      describe("bind to another baseController", function() {
        return it('should subcribe the calling baseController to another\'s channel', function() {
          spyOn(this.baseController, 'subscribe');
          this.baseController.bindTool('baseController-channel');
          return expect(this.baseController.subscribe).toHaveBeenCalledWith('baseController-channel', this.baseController.process);
        });
      });
      return describe("bind to a data source", function() {
        return it('should call the baseController\'s #getDataSource method', function() {
          spyOn(this.baseController, 'getDataSource');
          this.baseController.bindTool("GalaxyZooSubject", 10);
          return expect(this.baseController.getDataSource).toHaveBeenCalledWith("GalaxyZooSubject", 10);
        });
      });
    });
  });

}).call(this);
