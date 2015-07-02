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
      var item, result, _i, _len, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref18, _ref19, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9, _results;
      InteractiveSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        if (((_ref = result.recent.subjects[0]) != null ? (_ref1 = _ref.metadata) != null ? _ref1.survey : void 0 : void 0) === 'sloan' || ((_ref2 = result.recent.subjects[0]) != null ? (_ref3 = _ref2.metadata) != null ? _ref3.survey : void 0 : void 0) === 'sloan_singleband') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref4 = result.recent.subjects[0].metadata.mag) != null ? _ref4.abs_r : void 0,
            apparent_brightness: (_ref5 = result.recent.subjects[0].metadata.mag) != null ? _ref5.r : void 0,
            color: ((_ref6 = result.recent.subjects[0].metadata.mag) != null ? _ref6.u : void 0) - ((_ref7 = result.recent.subjects[0].metadata.mag) != null ? _ref7.r : void 0),
            absolute_radius: result.recent.subjects[0].metadata.absolute_size
          });
        } else if (((_ref8 = result.recent.subjects[0]) != null ? (_ref9 = _ref8.metadata) != null ? _ref9.survey : void 0 : void 0) === 'candels_2epoch') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref10 = result.recent.subjects[0].metadata.mag) != null ? _ref10.abs_H : void 0,
            apparent_brightness: (_ref11 = result.recent.subjects[0].metadata.mag) != null ? _ref11.H : void 0,
            color: ((_ref12 = result.recent.subjects[0].metadata.mag) != null ? _ref12.H : void 0) - ((_ref13 = result.recent.subjects[0].metadata.mag) != null ? _ref13.J : void 0),
            absolute_radius: result.recent.subjects[0].metadata.absolute_size
          });
        } else if (((_ref14 = result.recent.subjects[0]) != null ? (_ref15 = _ref14.metadata) != null ? _ref15.survey : void 0 : void 0) === 'goods_full') {
          item = InteractiveSubject.create({
            counters: result.recent.subjects[0].metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subjects[0].location.standard,
            zooniverse_id: result.recent.subjects[0].zooniverse_id,
            redshift: result.recent.subjects[0].metadata.redshift,
            absolute_brightness: (_ref16 = result.recent.subjects[0].metadata.mag) != null ? _ref16.abs_Z : void 0,
            apparent_brightness: (_ref17 = result.recent.subjects[0].metadata.mag) != null ? _ref17.Z : void 0,
            color: ((_ref18 = result.recent.subjects[0].metadata.mag) != null ? _ref18.I : void 0) - ((_ref19 = result.recent.subjects[0].metadata.mag) != null ? _ref19.Z : void 0),
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
