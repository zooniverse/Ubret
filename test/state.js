(function () {
  describe("U.State", function() {
    beforeEach(function() {
      this.state = new U.State();
    });

    describe("set", function() {
      it("should update the state object", function() {
        this.state.set('state', true);
        expect(this.state.state.state).to.be.true;
      })

      it("should trigger a state:'state' event ", function() {
        var stateSpy = sinon.spy();
        this.state.on('state:state', stateSpy);
        this.state.set('state', true);
        expect(stateSpy).to.have.been.calledWith(true);
      });
    });

    describe("U.watchState", function() {
      it('should call a function when all the required state is set', function() {
        var stateSpy = sinon.spy();
        U.watchState(this.state, ['state1', 'state2'], stateSpy);
        this.state.set('state1', true);
        expect(stateSpy).to.not.have.been.called;
        this.state.set('state2', true);
        expect(stateSpy).to.have.been.called;
      });

      it('should pass optional state to the callback function', function() {
        var stateSpy = sinon.spy();
        U.watchState(this.state, {required: ['state1'], optional: ['state2']}, stateSpy);
        this.state.set('state2', true);
        this.state.set('state1', true);
        expect(stateSpy).to.have.been.calledWith(true, true);
      });

      it('should call the callback when optional state is set', function() {
        var stateSpy = sinon.spy();
        U.watchState(this.state, {required: ['state1'], optional: ['state2']}, stateSpy);
        this.state.set('state1', true);
        expect(stateSpy).to.have.been.calledWith(true);
        stateSpy.reset();
        this.state.set('state2', true);
        expect(stateSpy).to.have.been.calledWith(true, true);
      });
    });
  });


}).call(this);
