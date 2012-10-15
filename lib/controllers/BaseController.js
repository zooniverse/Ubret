(function() {
  var BaseController, GalaxyZooSubject, InteractiveSubject, SkyServerSubject, Spine, pubSub, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Spine = require('spine');

  pubSub = require('node-pubsub');

  _ = require('underscore/underscore');

  GalaxyZooSubject = require('../models/GalaxyZooSubject');

  SkyServerSubject = require('../models/SkyServerSubject');

  InteractiveSubject = require('../models/InteractiveSubject');

  BaseController = (function(_super) {

    __extends(BaseController, _super);

    BaseController.prototype.name = 'BaseController';

    function BaseController() {
      this.start = __bind(this.start, this);

      this.process = __bind(this.process, this);

      this.selectData = __bind(this.selectData, this);

      this.removeSelectionFilter = __bind(this.removeSelectionFilter, this);

      this.addFilter = __bind(this.addFilter, this);

      this.filterData = __bind(this.filterData, this);

      this.getDataSource = __bind(this.getDataSource, this);
      BaseController.__super__.constructor.apply(this, arguments);
      this.data = new Array;
      this.filters = new Array;
      this.filteredData = new Array;
      this.selectedData = new Array;
      this.keys = new Array;
    }

    BaseController.prototype.publish = function(message) {
      return pubSub.publish(this.channel, message, this);
    };

    BaseController.prototype.subscribe = function(channel, callback) {
      pubSub.subscribe(channel, callback);
      return this.trigger('subscribed', channel);
    };

    BaseController.prototype.getDataSource = function(source, params) {
      var dataSource,
        _this = this;
      switch (source) {
        case 'GalaxyZooSubject':
          dataSource = GalaxyZooSubject;
          break;
        case 'SkyServerSubject':
          dataSource = SkyServerSubject;
          break;
        case 'InteractiveSubject':
          dataSource = InteractiveSubject;
      }
      return dataSource.fetch(params).always(function() {
        return _this.receiveData(dataSource.lastFetch);
      });
    };

    BaseController.prototype.receiveData = function(data) {
      this.data = data;
      this.start();
      return this.trigger('data-received', this);
    };

    BaseController.prototype.underscoresToSpaces = function(string) {
      return string.replace(/_/g, " ");
    };

    BaseController.prototype.capitalizeWords = function(string) {
      return string.replace(/(\b[a-z])/g, function(char) {
        return char.toUpperCase();
      });
    };

    BaseController.prototype.prettyKey = function(key) {
      return this.capitalizeWords(this.underscoresToSpaces(key));
    };

    BaseController.prototype.spacesToUnderscores = function(string) {
      return string.replace(/\s/g, "_");
    };

    BaseController.prototype.lowercaseWords = function(string) {
      return string.replace(/(\b[A-Z])/g, function(char) {
        return char.toLowerCase();
      });
    };

    BaseController.prototype.uglifyKey = function(key) {
      return this.spacesToUnderscores(this.lowercaseWords(key));
    };

    BaseController.prototype.bindTool = function(source, params) {
      if (params == null) {
        params = '';
      }
      if (params) {
        return this.getDataSource(source, params);
      } else {
        return this.subscribe(source, this.process);
      }
    };

    BaseController.prototype.extractKeys = function(datum) {
      var dataKey, key, undesiredKeys, value, _results;
      undesiredKeys = ['id', 'cid', 'image', 'zooniverse_id', 'objID', 'counters'];
      _results = [];
      for (key in datum) {
        value = datum[key];
        if (typeof value !== 'function') {
          dataKey = key;
        }
        if (__indexOf.call(undesiredKeys, dataKey) < 0) {
          _results.push(this.keys.push(dataKey));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    BaseController.prototype.filterData = function() {
      var filter, _i, _len, _ref, _results;
      this.filteredData = this.data;
      _ref = this.filters;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        filter = _ref[_i];
        _results.push(this.filteredData = _.filter(this.filteredData, filter.func));
      }
      return _results;
    };

    BaseController.prototype.addFilter = function(filter) {
      this.filters.push(filter);
      this.publish([
        {
          message: 'filter',
          filter: filter
        }
      ]);
      return this.start();
    };

    BaseController.prototype.removeFilter = function(filter) {
      this.filters = _.difference(this.filters, filter);
      this.publish([
        {
          message: 'unfilter',
          filter: filter
        }
      ]);
      return this.start();
    };

    BaseController.prototype.removeSelectionFilter = function() {
      delete this.selectionFilter;
      return this.selectedData = new Array;
    };

    BaseController.prototype.selectData = function() {
      console.log(this.selectionFilter);
      if (this.selectionFilter) {
        return this.selectedData = _.filter(this.filteredData, this.selectionFilter);
      }
    };

    BaseController.prototype.process = function(message) {
      switch (message.message) {
        case "selected":
          return this.select(message.item_id);
        case "filter":
          return this.addFilter(message.filter);
        case "unfilter":
          return this.removeFilter(message.filter);
      }
    };

    BaseController.prototype.start = function() {
      this.filterData();
      return this.selectData();
    };

    return BaseController;

  })(Spine.Controller);

  module.exports = BaseController;

}).call(this);
