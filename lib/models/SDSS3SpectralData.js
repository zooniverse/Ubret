(function() {
  var SDSS3SpectralData, Spine,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Spine = require('spine');

  SDSS3SpectralData = (function(_super) {

    __extends(SDSS3SpectralData, _super);

    function SDSS3SpectralData() {
      return SDSS3SpectralData.__super__.constructor.apply(this, arguments);
    }

    SDSS3SpectralData.configure('SDSS3SpectralData', 'ra', 'dec', 'z', 'wavelengths', 'best_fit', 'flux', 'spectralLines');

    SDSS3SpectralData.spectrumID = /(?:all|sdss|boss)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/;

    SDSS3SpectralData.fetch = function(sdssid) {
      var match, specLineUrl, spectrumUrl;
      match = sdssid.match(SDSS3SpectralData.spectrumID);
      if (match == null) {
        alert('SDSS Spectral ID is malformed.');
        return null;
      }
      spectrumUrl = "http://api.sdss3.org/spectrum?id=" + sdssid + "&format=json&fields=ra,dec,z,wavelengths,best_fit,flux";
      specLineUrl = "http://api.sdss3.org/spectrumLines?id=" + sdssid;
      return $.when($.ajax(spectrumUrl), $.ajax(specLineUrl)).done(function(spectrum, lines) {
        return SDSS3SpectralData.fromJSON(spectrum[0], lines);
      });
    };

    SDSS3SpectralData.fromJSON = function(spectrum, lines) {
      var item, key, line, spectralLines, value, _i, _len, _ref, _ref1, _results;
      SDSS3SpectralData.lastFetch = new Array;
      _ref = spectrum[0];
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        spectralLines = {};
        _ref1 = lines[0][key];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          line = _ref1[_i];
          spectralLines[line.name] = line.wavelength;
        }
        spectrum[0][key]['spectralLines'] = spectralLines;
        item = SDSS3SpectralData.create(spectrum[0][key]);
        _results.push(SDSS3SpectralData.lastFetch.push(item));
      }
      return _results;
    };

    return SDSS3SpectralData;

  }).call(this, Spine.Model);

  module.exports = SDSS3SpectralData;

}).call(this);
