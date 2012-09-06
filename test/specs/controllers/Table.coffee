require = window.require

describe 'Table', ->
  Table = require('controllers/Table')
  beforeEach ->
    @table = new Table
  
  describe "#parseFilter", ->
    beforeEach ->
      @outFunc = new Function("item",  "return(item['u'] < 8.999)")

    describe "string is in English", ->
      it 'should produce a function from a given filter string', ->
        inString = "u is less than 8.999"
        expect(@table.parseFilter(inString).toString()).toBe @outFunc.toString()

    describe "string has mathematical symbols", ->
      it 'should produce a function from a given filter string', ->
        inString = "u < 8.999"
        expect(@table.parseFilter(inString).toString()).toBe @outFunc.toString()

    describe "string has multiple predicates", ->
      it 'should produce a function from a given filter string', ->
        inString = "u < 8.999 and g > 9.283"
        outFunc = new Function("item", "return(item['u'] < 8.999) && (item['g'] > 9.283)")
        expect(@table.parseFilter(inString).toString()).toBe outFunc.toString()