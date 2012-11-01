if typeof require is 'function' and typeof exports is 'object' and typeof module is object
  Ubret = 
    Table: require './controllers/Table'
  
  module.exports = Ubret
else
  window.Ubret = new Object