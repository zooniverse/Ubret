(function() {
  describe("U.Tool", function() {
    beforeEach(function() {
      this.SinonTool = U.Tool.extend({
        name: 'SinonTool',
        stateResponders: [
          {
            whenState: 'prepared-data',
            responder: 'test'
          },
          {
            whenState: 'prepared-data state',
            responder: 'testState render'
          },
          {
            whenState: 'prepared-data state2',
            responder: 'testState2'
          }
        ],
        initialize: sinon.spy(),
        test: sinon.spy(),
        testState: sinon.spy(),
        render: sinon.spy(),
        testState2: sinon.spy()
      });

      this.tool = new this.SinonTool({
        id: 'id', 
        state: null, 
        dom: 'd3',
        data: [{a: 1, c: 2, b: 3, uid: 1},
               {a: 3, c: 19, b: 20, uid: 2},
               {a: 9, c: 17, b: 50, uid: 3}],
        selection: [1]
      });
      this.childTool = new this.SinonTool({id: 'id-2'});
    });

    it('should exist', function() {
      expect(this.tool).to.be.ok;
    });

    it('should call initialize function', function() {
      expect(this.tool.initialize).to.have.been.called;
    });

    it('should have an el defined', function() {
      expect(this.tool.el).to.be.ok;
      expect(this.tool.el.id).to.equal('id');
      expect(this.tool.el.className).to.equal('SinonTool');
    });

    it('should have d3el defined', function() {
      expect(this.tool.d3el).to.be.ok;
    });

    it('should not have $el defined', function () {
      expect(this.tool.$el).to.not.be.ok;
    });

    it('should only have fired the test responder', function() {
      expect(this.tool.test).to.have.been.called;
      expect(this.tool.testState2).to.not.have.been.called;
      expect(this.tool.testState).to.not.have.been.called;
      expect(this.tool.render).to.not.have.been.called;
    });

    describe('initializeStateResponders', function() {
      it('should set responder when responder is a function reference', function() {
        this.tool.test.reset();
        this.tool.state.set('state', true);
        expect(this.tool.testState).to.have.been.called;
        expect(this.tool.render).to.have.been.called;
        expect(this.tool.test).to.not.have.been.called;
        expect(this.tool.testState2).to.not.have.been.called;
      });
    });

    describe('setData', function() {
      it('should set the data state', function() {
        var spy = sinon.spy();
        this.tool.state.on('state:data', spy);
        this.tool.setData([{a: 1, b: 2, c: 3}]);
        expect(spy).to.have.been.called;
        expect(this.tool.state.get('data')).to.be.ok;
      });

      it('should trigger the data event', function() {
        var spy = sinon.spy();
        U.listenTo(this.tool.state, 'data', spy);
        this.tool.setData([{a: 1, b: 2, c: 3}]);
        expect(spy).to.have.been.called;
      });
    });

    describe('setSelection', function() {
      it('should set the selection state', function() {
        var spy = sinon.spy();
        this.tool.state.on('state:selection', spy);
        this.tool.setSelection([1, 2, 3]);
        expect(spy).to.have.been.called;
        expect(this.tool.state.get('selection')).to.have.length(3);
      });

      it('should trigger the selection event', function() {
        var spy = sinon.spy();
        U.listenTo(this.tool.state, 'selection', spy);
        this.tool.setSelection([1, 2, 3]);
        expect(spy).to.have.been.called;
      });
    });

    describe('parentTool', function() {
      beforeEach(function() {
        this.childTool.parentTool(this.tool);
      });

      it('should copy the childData and selection from the parent', function() {
        expect(this.childTool.state.get('data')).to.be.ok;
        expect(this.childTool.state.get('selection')).to.have.length(1);
        expect(this.childTool.state.get('selection')[0]).to.equal(1);
      });

      it('should set event listeners on data events', function() {
        this.tool.setData([{a: 1, b: 2, c: 3, uid: 1}]);
        expect(this.childTool.state.get('data').toArray()).to.have.length(1);
        expect(this.childTool.state.get('data').toArray())
          .to.have.deep.property('[0].a').and.equal(1);
      });

      it('should set event listeners on selection events', function() {
        this.tool.setSelection([2]);
        expect(this.childTool.state.get('selection')[0]).to.equal(2);
        expect(this.childTool.state.get('selection')).to.have.length(1);
      });

    });
  });
}).call(this);
