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

    SDSS3SpectralData.configure('SDSS3SpectralData', 'ra', 'dec', 'z', 'wavelengths', 'best_fit', 'flux');

    SDSS3SpectralData.spectrumID = /(?:all|sdss|boss)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/;

    SDSS3SpectralData.fetch = function(sdssid) {
      var match, params;
      match = sdssid.match(SDSS3SpectralData.spectrumID);
      if (match == null) {
        alert('SDSS Spectral ID is malformed.');
        return null;
      }
      params = {
        url: "http://api.sdss3.org/spectrum?id=" + sdssid + "&format=json&fields=ra,dec,z,wavelengths,best_fit,flux",
        success: SDSS3SpectralData.fromJSON
      };
      return $.ajax(params);
    };

    SDSS3SpectralData.fromJSON = function(json) {
      var item, key, value, _ref, _results;
      SDSS3SpectralData.lastFetch = new Array;
      _ref = json[0];
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        item = SDSS3SpectralData.create(json[0][key]);
        console.log(item);
        _results.push(SDSS3SpectralData.lastFetch.push(item));
      }
      return _results;
    };

    return SDSS3SpectralData;

  }).call(this, Spine.Model);

  module.exports = SDSS3SpectralData;

}).call(this);
