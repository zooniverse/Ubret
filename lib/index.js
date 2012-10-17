(function() {

  module.exports = require('./ubret');

  exports.GalaxyZooSubject = require('./models/GalaxyZooSubject');

  exports.SkyServerSubject = require('./models/SkyServerSubject');

  exports.Map = require('./controllers/Map');

  exports.Table = require('./controllers/Table');

  exports.Scatterplot = require('./controllers/Scatterplot');

  exports.SubjectViewer = require('./controllers/SubjectViewer');

  exports.Histogram = require('./controllers/Histogram');

  exports.Statistics = require('./controllers/Statistics');

  exports.BaseController = require('./controllers/BaseController');

  exports.WWT = require('./controllers/WWT');

  exports.Spectra = require('./controllers/Spectra');

}).call(this);
