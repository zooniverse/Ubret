(function() {
  describe("U.dispatch", function() {
    beforeEach(function() {
      this.testSpy = sinon.spy();
      this.restSpy = sinon.spy();
      this.estSpy = sinon.spy();
      this.dispatch = U.dispatch(U.identity, {
        'test' : [this.testSpy],
        'rest' : [this.restSpy],
        'res*' : [this.restSpy],
        '.*(est)*' : [this.estSpy]
      });
    });

    it("should dispatch based on applying regex to dispatch value", function() {
      this.dispatch('test', 'arg1', 'arg2');
      expect(this.testSpy).to.have.been.called
      expect(this.testSpy).to.have.been.calledWith('arg1', 'arg2', 'test');
      expect(this.estSpy).to.have.been.calledWith('arg1', 'arg2', 'test');
    });

    it("regex's should be anchored", function() {
      this.dispatch('testing', 'arg1', 'arg2');
      expect(this.testSpy).to.not.have.been.called;
      expect(this.estSpy).to.have.been.calledWith('arg1', 'arg2', 'testing');
    });
  });

  describe("U.pipeline", function() {
    it("should pass the returned value of fn in pipeline to the next step", function() {
      this.step1 = sinon.stub().returns([1, 2, 4]);
      this.step2 = sinon.stub().returns([3, 4, 5]);
      this.step3 = sinon.stub().returns([5, 6, 7]);
      this.pipeline = U.pipeline(this.step1, this.step2, this.step3);
      expect(this.pipeline([-1, 0, 2])).to.deep.equal([5, 6, 7]);
      expect(this.step1).to.have.been.calledWith([-1, 0, 2])
      expect(this.step2).to.have.been.calledWith([1, 2, 4])
      expect(this.step3).to.have.been.calledWith([3, 4, 5])
    });
  });
}).call(this);
