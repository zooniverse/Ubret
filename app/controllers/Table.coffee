Spine = require('spine')

class Table extends Spine.Controller
  constructor: ->
    super
    console.log 'Table'
    console.log 'subjects', @subjects
    @html require('views/table')(@subjects)
    
    
module.exports = Table