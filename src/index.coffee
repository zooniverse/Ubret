if typeof require is 'function' and typeof exports is 'object' and typeof module is 'object'
  Ubret = 
    Map: require './ubret/map'
    Statistics: require './ubret/statistics'
    SubjectViewer: require './ubret/subject_viewer'
    Table: require './ubret/table'
  
  module.exports = Ubret
else
  console.log 'here'
  window.Ubret = {}