(function() {
  var Ubret;

  Ubret = {
    Map: require('./controllers/Map'),
    Table: require('./controllers/Table'),
    Scatterplot: require('./controllers/Scatterplot'),
    SubjectViewer: require('./controllers/SubjectViewer'),
    Histogram: require('./controllers/Histogram'),
    Statistics: require('./controllers/Statistics'),
    BaseController: require('./controllers/BaseController'),
    WWT: require('./controllers/WWT'),
    Spectra: require('./controllers/Spectra')
  };

  module.exports = Ubret;

}).call(this);
