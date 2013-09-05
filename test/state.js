describe("U.State", function() {
  beforeEach(function() {
    this.state = new U.State();
  });

  describe("set", function() {
    it("should update the state object", function() {
      this.state.set('state', true);
      expect(this.state.state.state).to.be.true;
    })

    it("should trigger a 'state' event ", function() {
      var stateSpy = sinon.spy();
      this.state.on('state', stateSpy);
      this.state.set('state', true);
      expect(stateSpy).to.have.been.calledWith(true);
    });

    it("should parse setting string", function() {
      var stateSpy = sinon.spy()
      this.state.on('state.[0]', stateSpy)
      this.state.set('state.[0]', 'true')
      expect(stateSpy).to.have.been.calledWith('true')
    });
  });

  describe("with", function() {
    it('should create a function', function() {
      var withState = this.state.with(['state1', 'state2'], U.identity)
      expect(withState).to.be.a('function');
    });

    it('should call functions with the given state', function() {
      var spy1 = sinon.spy();
      var withState = this.state.with(['state1', 'state2'], spy1);
      this.state.set('state1', true);
      this.state.set('state2', true);
      withState();
      expect(spy1).to.have.been.calledWith({state1: true, state2: true});
    });
  });

  describe("when", function() {
    it('should call a function when all the required state is set', function() {
      var stateSpy = sinon.spy();
      this.state.when(['state1', 'state2'], [], stateSpy);
      this.state.set('state1', true);
      expect(stateSpy).to.not.have.been.called;
      this.state.set('state2', true);
      expect(stateSpy).to.have.been.called;
    });

    it('should pass optional state to the callback function', function() {
      var stateSpy = sinon.spy();
      this.state.when(['state1'], ['state2'], stateSpy);
      this.state.set('state2', true);
      this.state.set('state1', true);
      expect(stateSpy).to.have.been.calledWith({state1: true, state2: true});
    });

    it('should call the callback when optional state is set', function() {
      var stateSpy = sinon.spy();
      this.state.when(['state1'], ['state2'], stateSpy);
      this.state.set('state1', true);
      expect(stateSpy).to.have.been.calledWith({state1: true, state2: undefined});
      stateSpy.reset();
      this.state.set('state2', true);
      expect(stateSpy).to.have.been.calledWith({state1: true, state2: true});
    });
  });
});
