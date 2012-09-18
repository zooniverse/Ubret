(function() {
  var require;

  require = window.require;

  describe('Table', function() {
    var Table;
    Table = require('controllers/Table');
    beforeEach(function() {
      return this.table = new Table;
    });
    return describe("#parseFilter", function() {
      beforeEach(function() {
        return this.outFunc = new Function("item", "return(item['u'] < 8.999)");
      });
      describe("string is in English", function() {
        return it('should produce a function from a given filter string', function() {
          var inString;
          inString = "u is less than 8.999";
          return expect(this.table.parseFilter(inString)['func'].toString()).toBe(this.outFunc.toString());
        });
      });
      describe("string has mathematical symbols", function() {
        return it('should produce a function from a given filter string', function() {
          var inString;
          inString = "u < 8.999";
          return expect(this.table.parseFilter(inString)['func'].toString()).toBe(this.outFunc.toString());
        });
      });
      return describe("string has multiple predicates", function() {
        return it('should produce a function from a given filter string', function() {
          var inString, outFunc;
          inString = "u < 8.999 and g > 9.283";
          outFunc = new Function("item", "return(item['u'] < 8.999) && (item['g'] > 9.283)");
          return expect(this.table.parseFilter(inString)['func'].toString()).toBe(outFunc.toString());
        });
      });
    });
  });

}).call(this);
