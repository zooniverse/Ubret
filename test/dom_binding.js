(function () {
  var domBindingInterface = function() {
    beforeEach(function() {
      this.state = new U.State();
      this.renderSpy = sinon.spy();
      this.clickSpy = sinon.spy();
      this.binding = {
        watchState: ['state'],
        render: this.renderSpy,
        el: document.createElement('div'),
        state: this.state,
        events: {
          'click' : this.clickSpy
        }
      };
      this.domBinding(this.binding, this.state);
    });

    it("should bind its render function to state changes", function() {
      this.state.set('state', true);
      expect(this.renderSpy).to.have.been.called;
      expect(this.renderSpy).to.have.been.calledWith(true, 'state');
    });

    it("should set events", function() {
      if (!U.exists(this.binding.$el))
        return;
      this.state.set('state', true);
      $(this.binding.el).click();
      expect(this.clickSpy).to.have.been.called;
    });

  };

  describe("U.DomBinding", function() {
    beforeEach(function() {
      this.ctx = {
        removeWatch: sinon.spy(),
        attachDom: sinon.spy(),
        watchDom: sinon.spy()
      };
      this.state = new U.State();
      var options = {
        render: function() {return 'test'},
        watchState: ['state'],
        state: this.state
      };
      this.domBinding = _.bind(U.DomBinding, this.ctx);
      this.domBinding.call(this.ctx, options, this.state);
      this.state.set('state', true);
    });

    describe("should fullfil the DomBinding Interface", domBindingInterface);

    it("should call the attachDom method with the rest of render", function() {
      expect(this.ctx.attachDom).to.have.been.called;
    });

    it("should call the attachDom method with the rest of render", function() {
      expect(this.ctx.removeWatch).to.have.been.called;
    });

    it("should call the attachDom method with the rest of render", function() {
      expect(this.ctx.watchDom).to.have.been.called;
    });
  });

  describe("U.$DomBinding", function() {
    beforeEach(function() {
      this.domBinding = U.$DomBinding;
    });

    describe("should fullfil the DomBinding Interface", domBindingInterface);
  }); 

  describe("U.d3DomBinding", function() {
    beforeEach(function() {
      this.domBinding = U.d3DomBinding;
    });

    describe("should fullfil the DomBinding Interface", domBindingInterface);
  }); 
}).call(this);
