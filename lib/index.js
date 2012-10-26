(function() {
  var Ubret;

  Ubret = {
    Map: require('./controllers/Map'),
    Table: require('./controllers/Table'),
    Scatterplot: require('./controllers/Scatterplot'),
    SubjectViewer: require('./controllers/SubjectViewer'),
    Histogram: require('./controllers/Histogram'),
    Statistics: require('./controllers/Statistics'),
    Spectra: require('./controllers/Spectra')
  };

  module.exports = Ubret;

}).call(this);
