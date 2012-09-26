(function() {
  var Graph, Histogram, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Graph = require('./Graph');

  _ = require('underscore/underscore');

  Histogram = (function(_super) {

    __extends(Histogram, _super);

    function Histogram() {
      this.start = __bind(this.start, this);

      this.render = __bind(this.render, this);

      this.drawBars = __bind(this.drawBars, this);

      this.binData = __bind(this.binData, this);

      this.createXAxis = __bind(this.createXAxis, this);
      Histogram.__super__.constructor.apply(this, arguments);
      this.variable = this.variable || 'extinction_u';
      this.width = this.width || 640;
      this.height = this.height || 480;
    }

    Histogram.prototype.createXAxis = function() {
      var datum, lastItem, lastTick, xTicks, _i, _len, _ref;
      xTicks = new Array;
      _ref = this.binnedData;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        datum = _ref[_i];
        xTicks.push(datum.x);
      }
      lastItem = _.last(this.binnedData);
      lastTick = lastItem.x + lastItem.dx;
      xTicks.push(lastTick);
      return Histogram.__super__.createXAxis.call(this, xTicks, this.variable);
    };

    Histogram.prototype.binData = function() {
      var _this = this;
      this.values = _.map(this.filteredData, function(datum) {
        return parseFloat(datum[_this.variable]);
      });
      return this.binnedData = d3.layout.histogram()(this.values);
    };

    Histogram.prototype.drawBars = function() {
      var bar, formatCount,
        _this = this;
      formatCount = d3.format(",.0f");
      bar = this.svg.selectAll(".bar").data(this.binnedData).enter().append('g').attr('class', 'bar').attr('transform', function(d) {
        return "translate(" + (_this.x(d.x) - 1) + ", " + (_this.y(d.y)) + ")";
      });
      bar.append('rect').attr('x', 1).attr('width', this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x)).attr('height', function(d) {
        return _this.graphHeight - _this.y(d.y);
      });
      return bar.append('text').attr("dy", ".75em").attr("y", 6).attr("x", (this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x)) / 2).attr("text-anchor", "middle").text(function(d) {
        return formatCount(d.y);
      });
    };

    Histogram.prototype.render = function() {
      return this.html(require('../views/histogram')(this.channel));
    };

    Histogram.prototype.start = function() {
      this.filterData();
      this.binData();
      this.createGraph();
      this.createXScale(d3.min(this.values), d3.max(this.values));
      this.createYScale(0, d3.max(this.binnedData, function(d) {
        return d.y;
      }));
      this.createXAxis();
      this.createYAxis();
      return this.drawBars();
    };

    return Histogram;

  })(Graph);

  module.exports = Histogram;

}).call(this);
