(function() {
  var Api, InteractiveSubject, Spine, User,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Spine = require('spine');

  Api = require('zooniverse/lib/api');

  User = require('zooniverse/lib/models/user');

  InteractiveSubject = (function(_super) {

    __extends(InteractiveSubject, _super);

    function InteractiveSubject() {
      return InteractiveSubject.__super__.constructor.apply(this, arguments);
    }

    InteractiveSubject.configure('InteractiveSubject', 'redshift', 'color', 'subject', 'classification', 'counters', 'image', 'zooniverse_id', 'absolute_brightness', 'apparent_brightness', 'absolute_radius');

    InteractiveSubject.fetch = function(_arg) {
      var fetcher, limit, random, url, user;
      random = _arg.random, limit = _arg.limit, user = _arg.user;
      url = InteractiveSubject.url(random, limit, user);
      return fetcher = Api.getJSON(url, InteractiveSubject.fromJSON);
    };

    InteractiveSubject.url = function(random, limit, user) {
      var url;
      if (random) {
        url = '/user_groups/506a216fd10d240486000002/recents';
      } else if (user) {
        url = "/user_groups/" + User.current.user_group_id + "/user_recents";
      } else {
        url = "/user_groups/" + User.current.user_group_id + "/recents";
      }
      limit = parseInt(limit) + 5;
      if (limit !== 0) {
        url = url + ("?limit=" + limit + "&project_id=galaxy_zoo");
      }
      return url;
    };

    InteractiveSubject.fromJSON = function(json) {
      var item, result, _i, _len, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref18, _ref19, _ref2, _ref20, _ref21, _ref22, _ref23, _ref24, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9, _results;
      InteractiveSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        if ((_ref = (_ref1 = result.recent.subjects[0]) != null ? (_ref2 = _ref1.metadata) != null ? _ref2.survey : void 0 : void 0) === 'sloan' || _ref === 'sloan_singleband' || _ref === 'decals') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref3 = result.recent.subjects[0].metadata.mag) != null ? _ref3.abs_r : void 0,
            apparent_brightness: (_ref4 = result.recent.subjects[0].metadata.mag) != null ? _ref4.r : void 0,
            color: ((_ref5 = result.recent.subjects[0].metadata.mag) != null ? _ref5.u : void 0) - ((_ref6 = result.recent.subjects[0].metadata.mag) != null ? _ref6.r : void 0),
            absolute_radius: result.recent.subjects[0].metadata.absolute_size
          });
        } else if (((_ref7 = result.recent.subjects[0]) != null ? (_ref8 = _ref7.metadata) != null ? _ref8.survey : void 0 : void 0) === 'illustris') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref9 = result.recent.subjects[0].metadata.mag) != null ? _ref9.absmag_r : void 0,
            apparent_brightness: ((_ref10 = result.recent.subjects[0].metadata.mag) != null ? _ref10.absmag_r : void 0) - 36.756,
            color: ((_ref11 = result.recent.subjects[0].metadata.mag) != null ? _ref11.absmag_u : void 0) - ((_ref12 = result.recent.subjects[0].metadata.mag) != null ? _ref12.absmag_r : void 0),
            absolute_radius: result.recent.subjects[0].metadata.radius_half
          });
        } else if (((_ref13 = result.recent.subjects[0]) != null ? (_ref14 = _ref13.metadata) != null ? _ref14.survey : void 0 : void 0) === 'candels_2epoch') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref15 = result.recent.subjects[0].metadata.mag) != null ? _ref15.abs_H : void 0,
            apparent_brightness: (_ref16 = result.recent.subjects[0].metadata.mag) != null ? _ref16.H : void 0,
            color: ((_ref17 = result.recent.subjects[0].metadata.mag) != null ? _ref17.H : void 0) - ((_ref18 = result.recent.subjects[0].metadata.mag) != null ? _ref18.J : void 0),
            absolute_radius: result.recent.subjects[0].metadata.absolute_size
          });
        } else if (((_ref19 = result.recent.subjects[0]) != null ? (_ref20 = _ref19.metadata) != null ? _ref20.survey : void 0 : void 0) === 'goods_full') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref21 = result.recent.subjects[0].metadata.mag) != null ? _ref21.abs_Z : void 0,
            apparent_brightness: (_ref22 = result.recent.subjects[0].metadata.mag) != null ? _ref22.Z : void 0,
            color: ((_ref23 = result.recent.subjects[0].metadata.mag) != null ? _ref23.I : void 0) - ((_ref24 = result.recent.subjects[0].metadata.mag) != null ? _ref24.Z : void 0),
            absolute_radius: result.recent.subjects[0].metadata.absolute_size
          });
        }
        _results.push(InteractiveSubject.lastFetch.push(item));
      }
      return _results;
    };

    return InteractiveSubject;

  }).call(this, Spine.Model);

  module.exports = InteractiveSubject;

}).call(this);
