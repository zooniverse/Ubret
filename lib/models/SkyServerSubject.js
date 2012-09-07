(function() {
  var SkyServerSubject, Spine,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Spine = require('spine');

  SkyServerSubject = (function(_super) {

    __extends(SkyServerSubject, _super);

    function SkyServerSubject() {
      return SkyServerSubject.__super__.constructor.apply(this, arguments);
    }

    SkyServerSubject.configure('SkyServerSubject', 'objID', 'specObjID', 'ra', 'dec', 'raErr', 'decErr', 'b', 'l', 'mjd', 'type', 'u_band_magnitude', 'g_band_magnitude', 'r_band_magnitude', 'i_band_magnitude', 'z_band_magnitude', 'err_in_u_band_magnitude', 'err_in_g_band_magnitude', 'err_in_r_band_magnitude', 'err_in_i_band_magnitude', 'err_in_z_band_magnitude', 'petrosian_radius_u', 'petrosian_radius_g', 'petrosian_radius_r', 'petrosian_radius_i', 'petrosian_radius_z', 'extinction_u', 'extinction_g', 'extinction_r', 'extinction_i', 'extinction_z', 'fracDeV_u', 'fracDeV_g', 'fracDeV_r', 'fracDeV_i', 'fracDeV_z', 'zooniverse_id');

    SkyServerSubject.fetch = function(count) {
      var params;
      if (count == null) {
        count = 1;
      }
      count = parseInt(count);
      count += 1;
      params = {
        dataType: 'jsonp',
        url: "http://skyserver.herokuapp.com/skyserver/random.json",
        data: {
          count: count
        },
        callback: 'givemegalaxies',
        success: this.fromJSON
      };
      return $.ajax(params);
    };

    SkyServerSubject.fromJSON = function(json) {
      var item, result, _i, _len, _results;
      SkyServerSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        if (result !== json[1]) {
          item = SkyServerSubject.create({
            zooniverse_id: result.objID,
            objID: result.objID,
            specObjID: result.specObjID,
            ra: result.ra,
            dec: result.dec,
            raErr: result.raErr,
            decErr: result.decErr,
            b: result.b,
            l: result.l,
            mjd: result.mjd,
            type: result.type,
            u_band_magnitude: result.u,
            g_band_magnitude: result.g,
            r_band_magnitude: result.r,
            i_band_magnitude: result.i,
            z_band_magnitude: result.z,
            err_in_u_band_magnitude: result.err_u,
            err_in_g_band_magnitude: result.err_g,
            err_in_r_band_magnitude: result.err_r,
            err_in_i_band_magnitude: result.err_i,
            err_in_z_band_magnitude: result.err_z,
            petrosian_radius_u: result.petroR90_u,
            petrosian_radius_g: result.petroR90_g,
            petrosian_radius_r: result.petroR90_r,
            petrosian_radius_i: result.petroR90_i,
            petrosian_radius_z: result.petroR90_z,
            extinction_u: result.extinction_u,
            extinction_g: result.extinction_g,
            extinction_r: result.extinction_r,
            extinction_i: result.extinction_i,
            extinction_z: result.extinction_z,
            fracDeV_u: result.fracDeV_u,
            fracDeV_g: result.fracDeV_g,
            fracDeV_r: result.fracDeV_r,
            fracDeV_i: result.fracDeV_i,
            fracDeV_z: result.fracDeV_z
          });
          _results.push(SkyServerSubject.lastFetch.push(item));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return SkyServerSubject;

  }).call(this, Spine.Model);

  module.exports = SkyServerSubject;

}).call(this);
