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

    InteractiveSubject.configure('InteractiveSubject', 'redshift', 'color', 'subject', 'classification', 'type', 'counters');

    InteractiveSubject.fetch = function(_arg) {
      var fetcher, limit, random, url, user;
      random = _arg.random, limit = _arg.limit, user = _arg.user;
      url = InteractiveSubject.url(random, limit, user);
      return fetcher = Api.get(url, InteractiveSubject.fromJSON);
    };

    InteractiveSubject.url = function(random, limit, user) {
      var url;
      if (random) {
        url = '/user_groups/random-classifications';
      } else if (user) {
        url = "/user_groups/" + User.current.user_group_id + "/user_recents";
      } else {
        url = "/user-groups/" + User.current.user_group_id + "/recents";
      }
      if (limit !== 0) {
        url = url + ("?limit=" + limit);
      }
      return url;
    };

    InteractiveSubject.fromJSON = function(json) {
      var item, result, _i, _len, _results;
      InteractiveSubject.lastFetch = new Array;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        result = json[_i];
        item = InteractiveSubject.create({
          counters: result.recent.subject.metadata.counters,
          classification: result.recent.user.classification,
          type: InteractiveSubject.findType(result.recent.subject.metadata.counters),
          image: result.recent.subject.location.standard
        });
        _results.push(InteractiveSubject.lastFetch.push(item));
      }
      return _results;
    };

    InteractiveSubject.findType = function(subject) {
      if (subject.smooth > subject.feature && subject.smooth > subject.artifact) {
        return 'smooth';
      } else if (subject.feature > subject.smooth && subject.feature > subject.artifact) {
        return 'feature';
      } else {
        return 'artifact';
      }
    };

    return InteractiveSubject;

  }).call(this, Spine.Model);

  module.exports = InteractiveSubject;

}).call(this);
