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

    InteractiveSubject.configure('InteractiveSubject', 'redshift', 'color', 'subject', 'classification', 'type');

    InteractiveSubject.fetch = function(random, limit, user) {
      var fetcher, url;
      if (limit == null) {
        limit = 0;
      }
      if (user == null) {
        user = false;
      }
      url = InteractiveSubject.url(random, limit, user);
      return fetcher = Api.get(url, InteractiveSubject.fromJSON);
    };

    InteractiveSubject.url = function(random, limit, user) {
      var url;
      if (random) {
        url = '/projects/galaxy_zoo/user-groups/random-classifications';
      } else if (user) {
        url = "/projects/galaxy_zoo/user-groups/" + User.current.group + "/classifications/users/" + User.current.id + "/classifications";
      } else {
        url = '/projects/galaxy_zoo/user-groups/#{User.current.group}/classifications';
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
          redshift: InteractiveSubject.result.metadata.redshift,
          color: InteractiveSubject.result.metadata.color,
          subject: InteractiveSubject.result.subject,
          classification: InteractiveSubject.result.classification,
          type: InteractiveSubject.findType(InteractiveSubject.result.subject)
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
