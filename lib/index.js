(function() {

  module.exports = require('./lib/ubret');

  exports.GalaxyZooSubject = require('./lib/models/GalazyZooSubject');

  exports.SkyServerSubject = require('./lib/models/SkyServerSubject');

  exports.Map = require('./lib/controllers/Map');

  exports.Table = require('./lib/controllers/Table');

  exports.Scatterplot = require('./lib/controllers/Scatterplot');

  exports.SubjectViewer = require('./lib/controllers/SubjectViewer');

  exports.Histogram = require('./lib/controllers/Histogram');

  exports.BaseController = require('./lib/controllers/BaseController');

}).call(this);
