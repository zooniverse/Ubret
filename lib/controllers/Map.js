(function() {
  var BaseController, Map, SubjectViewer, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require('underscore/underscore');

  BaseController = require('./BaseController');

  SubjectViewer = require('./SubjectViewer');

  Map = (function(_super) {

    __extends(Map, _super);

    Map.prototype.name = 'Map';

    Map.mapOptions = {
      attributionControl: false
    };

    L.Icon.Default.imagePath = 'css/images';

    Map.prototype.default_icon = new L.icon({
      className: 'default_icon',
      iconUrl: '/css/images/marker-icon.png',
      iconSize: [25, 41],
      iconAnchor: [13, 41]
    });

    Map.prototype.selected_icon = new L.icon({
      className: 'selected_icon',
      iconUrl: '/css/images/marker-icon-orange.png',
      iconSize: [25, 41],
      iconAnchor: [13, 41]
    });

    function Map() {
      this.setFullscreenMode = __bind(this.setFullscreenMode, this);

      this.selectSubject = __bind(this.selectSubject, this);

      this.selected = __bind(this.selected, this);

      this.plotObjects = __bind(this.plotObjects, this);

      this.plotObject = __bind(this.plotObject, this);

      this.createSky = __bind(this.createSky, this);

      this.start = __bind(this.start, this);

      this.render = __bind(this.render, this);
      Map.__super__.constructor.apply(this, arguments);
      this.circles = [];
      this.subscribe(this.subChannel, this.process);
    }

    Map.prototype.render = function() {
      return this.html(require('../views/map')({
        index: this.index
      }));
    };

    Map.prototype.start = function() {
      if (!this.map) {
        this.createSky();
      }
      if (this.data) {
        return this.plotObjects();
      }
    };

    Map.prototype.createSky = function() {
      this.map = L.map("sky-" + this.index, Map.mapOptions).setView([0, 180], 6);
      this.layer = L.tileLayer('/tiles/#{zoom}/#{tilename}.jpg', {
        maxZoom: 7
      });
      this.layer.getTileUrl = function(tilePoint) {
        var convertTileUrl, url, zoom;
        zoom = this._getZoomForUrl();
        convertTileUrl = function(x, y, s, zoom) {
          var d, e, f, g, pixels;
          pixels = Math.pow(2, zoom);
          d = (x + pixels) % pixels;
          e = (y + pixels) % pixels;
          f = "t";
          g = 0;
          while (g < zoom) {
            pixels = pixels / 2;
            if (e < pixels) {
              if (d < pixels) {
                f += "q";
              } else {
                f += "r";
                d -= pixels;
              }
            } else {
              if (d < pixels) {
                f += "t";
                e -= pixels;
              } else {
                f += "s";
                d -= pixels;
                e -= pixels;
              }
            }
            g++;
          }
          return {
            x: x,
            y: y,
            src: f,
            s: s
          };
        };
        url = convertTileUrl(tilePoint.x, tilePoint.y, 1, zoom);
        return "/tiles/" + zoom + "/" + url.src + ".jpg";
      };
      return this.layer.addTo(this.map);
    };

    Map.prototype.plotObject = function(subject, options) {
      var circle, coords, icon, subject_viewer,
        _this = this;
      coords = [subject.dec, subject.ra];
      options = icon = new L.icon({
        iconSize: [25, 41],
        iconAnchor: [13, 41]
      });
      circle = new L.marker(coords, options);
      circle.zooniverse_id = subject.zooniverse_id;
      circle.addTo(this.map);
      subject_viewer = new SubjectViewer;
      subject_viewer.receiveData([subject]);
      subject_viewer.render();
      circle.bindPopup(subject_viewer.el.get(0).outerHTML, {
        maxWidth: 460
      });
      circle.on('click', function() {
        _this.selectSubject(circle);
        return _this.publish([
          {
            message: "selected",
            item_id: circle.zooniverse_id
          }
        ]);
      });
      return this.circles.push(circle);
    };

    Map.prototype.plotObjects = function() {
      var latlng, marker, subject, _i, _j, _len, _len1, _ref, _ref1;
      _ref = this.circles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        this.map.removeLayer(marker);
      }
      this.circles = new Array;
      this.filterData();
      _ref1 = this.filteredData;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        subject = _ref1[_j];
        this.plotObject(subject);
      }
      latlng = new L.LatLng(this.data[0].dec, this.data[0].ra);
      return this.map.panTo(latlng);
    };

    Map.prototype.selected = function(itemId) {
      var c, circle, item, latlng;
      item = _.find(this.data, function(subject) {
        return subject.zooniverse_id = itemId;
      });
      latlng = new L.LatLng(item.dec, item.ra);
      circle = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.circles;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          if (c.zooniverse_id === itemId) {
            _results.push(c);
          }
        }
        return _results;
      }).call(this))[0];
      return this.selectSubject(circle);
    };

    Map.prototype.selectSubject = function(circle) {
      if (this.selected_subject != null) {
        this.selected_subject.setIcon(this.default_icon);
      }
      this.selected_subject = circle;
      circle.openPopup();
      return circle.setIcon(this.selected_icon);
    };

    Map.prototype.setFullscreenMode = function() {
      this.el.addClass('fullscreen');
      this.el.children('div').css({
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        z_index: '0'
      });
      return this.map.invalidateSize(true);
    };

    return Map;

  })(BaseController);

  module.exports = Map;

}).call(this);
