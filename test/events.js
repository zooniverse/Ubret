(function() {
  describe("U.EventEmitter", function() {
    beforeEach(function() {
      this.eventEmitter = new U.EventEmitter();
    });

    it("should exist", function() {
      expect(this.eventEmitter).to.be.ok;
    });

    it("off() - should remove all event listeners", function() {
      var cbSpy = sinon.spy()
      this.eventEmitter.on("event!", cbSpy);
      this.eventEmitter.off();
      this.eventEmitter.trigger('event!');
      expect(cbSpy).to.not.have.been.called;
    });

    it("off(event) - should remove all listeners for event", function() {
      var spy1 = sinon.spy();
      var spy2 = sinon.spy();
      this.eventEmitter.on("event!", spy1);
      this.eventEmitter.on("event2!", spy2);
      this.eventEmitter.off("event2!");
      this.eventEmitter.trigger('event2!');
      this.eventEmitter.trigger('event!');
      expect(spy1).to.have.been.called;
      expect(spy2).to.not.have.been.called;
    });

    it("on/trigger, - register an event listener and to respond to a trigger", function() {
      var cbSpy = sinon.spy();
      this.eventEmitter.on("event!", cbSpy);
      this.eventEmitter.trigger('event!');
      expect(cbSpy).to.have.been.called;
    });
  });

  describe("U.listenTo", function() {
    it("it should create a listener on the object", function() {
      var cbSpy = sinon.spy()
      this.eventEmitter = new U.EventEmitter();
      U.listenTo(this.eventEmitter, 'event!', cbSpy);
      this.eventEmitter.trigger('event!');
      expect(cbSpy).to.have.been.called;
    });
  });

  describe("U.stopListening", function() {
    it("it should remove listeners from the object", function() {
      var cbSpy = sinon.spy()
      this.eventEmitter = new U.EventEmitter();
      U.listenTo(this.eventEmitter, 'event!', cbSpy);
      U.stopListening(this.eventEmitter, 'event!');
      this.eventEmitter.trigger('event!');
      expect(cbSpy).to.not.have.been.called;
    });
  });
}).call(this);
