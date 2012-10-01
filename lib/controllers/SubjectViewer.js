(function() {
  var BaseController, SubjectViewer, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  SubjectViewer = (function(_super) {

    __extends(SubjectViewer, _super);

    function SubjectViewer() {
      this.select = __bind(this.select, this);

      this.prevSubject = __bind(this.prevSubject, this);

      this.nextSubject = __bind(this.nextSubject, this);

      this.render = __bind(this.render, this);

      this.start = __bind(this.start, this);
      SubjectViewer.__super__.constructor.apply(this, arguments);
    }

    SubjectViewer.prototype.events = {
      'click .next': 'nextSubject',
      'click .back': 'prevSubject'
    };

    SubjectViewer.prototype.start = function() {
      this.count = 0;
      return this.render();
    };

    SubjectViewer.prototype.render = function() {
      var keys, subject;
      this.filterData();
      subject = this.filteredData[this.count];
      this.publish([
        {
          message: 'selected',
          item_id: subject != null ? subject.zooniverse_id : void 0
        }
      ]);
      this.keys = new Array;
      this.extractKeys(subject);
      keys = this.keys;
      return this.html(require('../views/subject_viewer')({
        subject: subject,
        keys: keys,
        count: this.filteredData.length
      }));
    };

    SubjectViewer.prototype.nextSubject = function() {
      this.count += 1;
      if (this.count >= this.filteredData.length) {
        this.count = 0;
      }
      return this.render();
    };

    SubjectViewer.prototype.prevSubject = function() {
      this.count -= 1;
      if (this.count < 0) {
        this.count = this.filteredData.length - 1;
      }
      return this.render();
    };

    SubjectViewer.prototype.select = function(itemId) {
      var subject, subjectIndex;
      subject = _.find(this.filteredData, function(datum) {
        return datum.zooniverse_id === itemId;
      });
      subjectIndex = _.indexOf(this.filteredData, subject);
      this.count = subjectIndex;
      this.render();
      return this.publish([
        {
          message: 'selected',
          item_id: itemId
        }
      ]);
    };

    return SubjectViewer;

  })(BaseController);

  module.exports = SubjectViewer;

}).call(this);
