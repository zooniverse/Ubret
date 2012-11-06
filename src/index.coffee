if typeof require is 'function' and typeof exports is 'object' and typeof module is object
  Ubret = 
    Map: require'./controllers/map'
    Statistics: require './controllers/statistics'
    SubjectViewer: require './controllers/subject_viewer'
    Table: require './controllers/table'
  
  module.exports = Ubret
else
  window.Ubret = new Object