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
        url = url + ("?limit=" + limit);
      }
      return url;
    };

    InteractiveSubject.fromJSON = function(json) {
      var item, result, _i, _len, _ref, _ref1, _ref2, _ref3, _results;
      InteractiveSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        if (result.recent.subject.metadata.survey === 'sloan') {
          item = InteractiveSubject.create({
            counters: result.recent.subject.metadata.counters,
            classification: result.recent.user.classification,
            image: result.recent.subject.location.standard,
            zooniverse_id: result.recent.subject.zooniverse_id,
            redshift: result.recent.subject.metadata.redshift,
            absolute_brightness: (_ref = result.recent.subject.metadata.mag) != null ? _ref.abs_r : void 0,
            apparent_brightness: (_ref1 = result.recent.subject.metadata.mag) != null ? _ref1.r : void 0,
            color: ((_ref2 = result.recent.subject.metadata.mag) != null ? _ref2.u : void 0) - ((_ref3 = result.recent.subject.metadata.mag) != null ? _ref3.r : void 0),
            absolute_radius: result.recent.subject.metadata.absolute_size
          });
          _results.push(InteractiveSubject.lastFetch.push(item));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return InteractiveSubject;

  }).call(this, Spine.Model);

  module.exports = InteractiveSubject;

}).call(this);
