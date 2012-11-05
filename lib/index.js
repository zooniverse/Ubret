(function() {
  var Ubret;

  if (typeof require === 'function' && typeof exports === 'object' && typeof module === object) {
    Ubret = {
      Statistics: require('./controllers/Statistics'),
      SubjectViewer: require('./controllers/SubjectViewer'),
      Table: require('./controllers/Table')
    };
    module.exports = Ubret;
  } else {
    window.Ubret = new Object;
  }

}).call(this);
