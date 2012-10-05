(function() {
  var Api, GalaxyZooSubject, Spine,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Api = require('zooniverse/lib/api');

  Spine = require('spine');

  GalaxyZooSubject = (function(_super) {

    __extends(GalaxyZooSubject, _super);

    GalaxyZooSubject.configure('GalaxyZooSubject', "image", "magnitude", "ra", "dec", "zooniverse_id", "petrosian_radius", "survey", "survey_id");

    function GalaxyZooSubject() {
      GalaxyZooSubject.__super__.constructor.apply(this, arguments);
    }

    GalaxyZooSubject.url = function(params) {
      return this.withParams("/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects", params);
    };

    GalaxyZooSubject.withParams = function(url, params) {
      if (url == null) {
        url = '';
      }
      if (params) {
        url += '?' + $.param(params);
      }
      return url;
    };

    GalaxyZooSubject.fetch = function(count) {
      var fetcher;
      if (count == null) {
        count = 1;
      }
      return fetcher = Api.get(this.url({
        limit: count
      }), this.fromJSON);
    };

    GalaxyZooSubject.fromJSON = function(json) {
      var item, result, _i, _len, _results;
      GalaxyZooSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        item = GalaxyZooSubject.create({
          image: result.location.standard,
          magnitdue: result.metadata.magnitude,
          ra: result.coords[0],
          dec: result.coords[1],
          zooniverse_id: result.zooniverse_id,
          petrosian_radius: result.metadata.petrorad_r,
          survey: result.metadata.survey,
          survey_id: result.metadata.sdss_id || result.metadata.hubble_id
        });
        _results.push(GalaxyZooSubject.lastFetch.push(item));
      }
      return _results;
    };

    GalaxyZooSubject.newImage = function(location) {
      var image;
      image = new Image;
      image.src = location;
      return image;
    };

    return GalaxyZooSubject;

  }).call(this, Spine.Model);

  module.exports = GalaxyZooSubject;

}).call(this);
