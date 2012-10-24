(function() {
  var BaseController, Statistics, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  Statistics = (function(_super) {

    __extends(Statistics, _super);

    Statistics.prototype.name = "Statistics";

    Statistics.prototype.events = {
      'change #select-key': 'changeSelectedKey'
    };

    function Statistics() {
      this.getKurtosis = __bind(this.getKurtosis, this);

      this.getSkew = __bind(this.getSkew, this);

      this.getPercentile = __bind(this.getPercentile, this);

      this.getStandardDeviation = __bind(this.getStandardDeviation, this);

      this.getVariance = __bind(this.getVariance, this);

      this.getMax = __bind(this.getMax, this);

      this.getMin = __bind(this.getMin, this);

      this.getMode = __bind(this.getMode, this);

      this.getMedian = __bind(this.getMedian, this);

      this.getMean = __bind(this.getMean, this);

      this.selectKey = __bind(this.selectKey, this);

      this.changeSelectedKey = __bind(this.changeSelectedKey, this);

      this.start = __bind(this.start, this);

      this.render = __bind(this.render, this);
      Statistics.__super__.constructor.apply(this, arguments);
      this.currentKey = 'dec';
      this.stats = [];
    }

    Statistics.prototype.render = function() {
      var subject;
      subject = this.filteredData[0];
      this.keys = new Array;
      this.extractKeys(subject);
      return this.html(require('../views/statistics')({
        keys: this.keys,
        stats: this.stats,
        currentKey: this.currentKey
      }));
    };

    Statistics.prototype.start = function() {
      var data;
      this.filterData();
      data = _.pluck(this.filteredData, this.currentKey);
      this.stats = [];
      if (_.any(data, (function(datum) {
        return _.isNaN(parseFloat(datum));
      }))) {

      } else {
        data = _.map(data, function(num) {
          return parseFloat(num);
        });
      }
      this.stats.push(this.getMean(data));
      this.stats.push(this.getMedian(data));
      this.stats.push(this.getMode(data));
      this.stats.push(this.getMin(data));
      this.stats.push(this.getMax(data));
      this.stats.push(this.getVariance(data));
      this.stats.push(this.getStandardDeviation(data));
      this.stats.push(this.getPercentile(data));
      this.stats.push(this.getSkew(data));
      this.stats.push(this.getKurtosis(data));
      return this.render();
    };

    Statistics.prototype.changeSelectedKey = function(e) {
      this.currentKey = $(e.currentTarget).val();
      return this.start();
    };

    Statistics.prototype.selectKey = function(key) {
      this.currentKey = key;
      return this.start();
    };

    Statistics.prototype.getMean = function(data) {
      var average, average_object;
      average = _.reduce(data, (function(memo, num) {
        return memo + num;
      })) / data.length;
      return average_object = {
        'label': 'Mean',
        'value': average
      };
    };

    Statistics.prototype.getMedian = function(data) {
      var median, median_object, mid_point;
      data = _.sortBy(data, function(num) {
        return num;
      });
      mid_point = data.length / 2;
      if (mid_point % 1) {
        median = (data[Math.floor(mid_point)] + data[Math.ceil(mid_point)]) / 2;
      } else {
        median = data[data.length / 2];
      }
      return median_object = {
        'label': 'Median',
        'value': median
      };
    };

    Statistics.prototype.getMode = function(data) {
      var key, keys, mode, mode_data, mode_object, _i, _len;
      data = _.groupBy(data, function(datum) {
        return datum;
      });
      keys = _.keys(data);
      mode_data = [];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        mode_data.push({
          'key': key,
          'num': data[key].length
        });
      }
      mode = _.max(mode_data, function(datum) {
        return datum.num;
      });
      return mode_object = {
        'label': 'Mode',
        'value': mode.key
      };
    };

    Statistics.prototype.getMin = function(data) {
      var min_object;
      return min_object = {
        'label': 'Minimum',
        'value': _.min(data)
      };
    };

    Statistics.prototype.getMax = function(data) {
      var max_object;
      return max_object = {
        'label': 'Maximum',
        'value': _.max(data)
      };
    };

    Statistics.prototype.getVariance = function(data) {
      var data_count, mean, variance, variance_data, variance_object;
      data_count = data.length;
      mean = this.getMean(data);
      data = _.map(data, function(datum) {
        return Math.pow(Math.abs(datum - mean.value), 2);
      });
      variance_data = _.reduce(data, function(memo, datum) {
        return memo + datum;
      });
      variance = variance_data / data_count;
      return variance_object = {
        'label': 'Variance',
        'value': variance
      };
    };

    Statistics.prototype.getStandardDeviation = function(data) {
      var standard_deviation, standard_deviation_object, variance;
      variance = (this.getVariance(data)).value;
      standard_deviation = Math.sqrt(variance);
      return standard_deviation_object = {
        'label': 'Standard Deviation',
        'value': standard_deviation
      };
    };

    Statistics.prototype.getPercentile = function(data) {
      var i, percent, percentile, percentile_data, percentile_object, value_object, _i;
      data = _.sortBy(data, function(datum) {
        return datum;
      });
      percentile_data = [];
      for (i = _i = 1; _i <= 10; i = ++_i) {
        percent = i / 10;
        percentile = data[(data.length * percent) - 1];
        value_object = {
          'label': (percent * 100) + 'th',
          'value': percentile
        };
        percentile_data.push(value_object);
      }
      return percentile_object = {
        'label': 'Percentile',
        'value': percentile_data,
        'view': require('../views/statistics_percentile')({
          data: percentile_data
        })
      };
    };

    Statistics.prototype.getSkew = function(data) {
      var denom, mean, skew, skew_object, standard_deviation, sum;
      mean = (this.getMean(data)).value;
      standard_deviation = (this.getStandardDeviation(data)).value;
      sum = _.reduce(data, (function(memo, datum) {
        return Math.pow(datum - mean, 3) + memo;
      }), 0);
      denom = data.length * Math.pow(standard_deviation, 3);
      skew = sum / denom;
      return skew_object = {
        'label': 'Skew',
        'value': skew
      };
    };

    Statistics.prototype.getKurtosis = function(data) {
      var denom, kurtosis, kurtosis_object, mean, standard_deviation, sum;
      mean = (this.getMean(data)).value;
      standard_deviation = (this.getStandardDeviation(data)).value;
      sum = _.reduce(data, (function(memo, datum) {
        return Math.pow(datum - mean, 4) + memo;
      }), 0);
      denom = data.length * Math.pow(standard_deviation, 4);
      kurtosis = sum / denom;
      return kurtosis_object = {
        'label': 'Kurtosis',
        'value': kurtosis
      };
    };

    return Statistics;

  })(BaseController);

  module.exports = Statistics;

}).call(this);
