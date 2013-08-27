(function() {
  describe("U.Data", function() {
    beforeEach(function() {
      this.data = new U.Data(
        [{a: 1, b: 2, c: 3},
         {a: 2, b: 7, c: 9},
         {a: 1, b: 10, c: 12}]);
    });
    it('should exist', function() {
      expect(this.data).to.be.ok;
    });

    describe("toArray", function() {
      it('should return the data as an array', function() {
        expect(this.data.toArray()).to.be.an('array');
        expect(this.data.toArray()).to.have.length(3);
      });
    });

    describe("keys", function() {
      it('should return all unique keys inside data', function () {
        expect(this.data.keys()).to.deep.equal(['a', 'b', 'c']);
      });
    });

    describe("filter", function() {
      it('should return a new data object', function() {
        expect(this.data.filter(function(d) { return d.a === 2;}))
          .to.not.eql(this.data);
      });
      it('should return filtered results', function() {
        var filtered = this.data
          .filter(function(d) { return d.a === 2;});
        console.log(filtered);
        expect(filtered.toArray()).to.have.length(1);
        expect(filtered.toArray())
          .to.have.deep.property('[0].a').and.equal(2);
      });
    });

    describe("removeFilter", function() {
      beforeEach(function() {
        this.func = function(d) { return d.a === 2;}
        this.filtered = this.data.filter(this.func);
      });
      it('should return a new data object', function() {
        expect(this.filtered.removeFilter(this.func))
          .to.not.eql(this.filtered);
      });
      it('should remove a filter from the object', function() {
        expect(this.filtered.removeFilter(this.func).toArray())
          .to.not.eql(this.filtered.toArray())
      }); 
    });

    describe("addField", function() {
      it('should throw an error when field object isn\'t valid', function() {
        expect(this.data.addField).to.throw(Error);
      });

      it('should add a field to the dataset', function() {
        expect(this.data.addField({
          name: 'color', fn: function(d) { return d.a + d.b;}}).toArray())
          .to.have.deep.property('[0].color').and.equal(3);
      });
    });

    describe("removeField", function() {
      it("should remove an added field", function() {
        var field, fielded;
        field = {name: 'color', fn: function(d) { return d.a + d.b;}}
        fielded = this.data.addField(field);
        expect(this.data.removeField(field).toArray).to.not.have
          .deep.property('[0].color');
      });
    });

    describe("project", function() {
      it("should produce an array with the selected fields", function() {
        var data = this.data.project('a', 'b').toArray();
        expect(data).to.have.deep.property('[0].a').and.equal(1);
        expect(data).to.have.deep.property('[0].b').and.equal(2);
        expect(data).to.not.have.deep.property('[0].c');
      });

      it("should have all fields when given '*' as first arg", function() {
        var data = this.data.project('*').toArray();
        expect(data).to.have.deep.property('[0].a').and.equal(1);
        expect(data).to.have.deep.property('[0].b').and.equal(2);
        expect(data).to.have.deep.property('[0].c').and.equal(3);
      });
    });

    describe("sort", function() {
      it("should sort the data in the order specified", function() {
        expect(this.data.sort('c', 'a').toArray())
          .to.have.deep.property('[0].c').and.equal(3);
        expect(this.data.sort('c', 'd').toArray())
          .to.have.deep.property('[0].c').and.equal(12);
      });
    });
    describe("paginate", function() {
      it("should split the array into arrays of specified size", function() {
        expect(this.data.paginate(2).toArray()).to.have.length(2);
        expect(this.data.paginate(2).toArray()[0]).to.have.length(2);
        expect(this.data.paginate(2).toArray()[1]).to.have.length(1);
      });
    });
    describe("query", function() {
      it("should return a data object from the designed query", function() {
        var data = this.data.query({
          select: ['a', 'b', 'color'],
          where: [function(d) { return d.a > 1; }],
          withFields: [{name: 'color', fn: function(d) { return d.a - d.c }}],
          sort: {prop: 'color', order: 'd'}});
        expect(data.toArray()).to.have.length(1)
        expect(data.toArray()).to.have.deep.property('[0].color').and.eql(-7);
      });
    });
  });
}).call(this);