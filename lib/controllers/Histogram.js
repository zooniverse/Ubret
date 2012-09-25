(function() {
  var BaseController, Histogram, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  Histogram = (function(_super) {

    __extends(Histogram, _super);

    function Histogram() {
      this.start = __bind(this.start, this);

      this.render = __bind(this.render, this);

      this.drawBars = __bind(this.drawBars, this);

      this.createGraph = __bind(this.createGraph, this);

      this.createYScale = __bind(this.createYScale, this);

      this.createXScale = __bind(this.createXScale, this);

      this.binData = __bind(this.binData, this);

      this.createYAxis = __bind(this.createYAxis, this);

      this.createXAxis = __bind(this.createXAxis, this);
      Histogram.__super__.constructor.apply(this, arguments);
      console.log(this.variable);
      this.variable = this.variable || 'extinction_u';
      this.width = this.width || 640;
      this.height = this.height || 480;
    }

    Histogram.prototype.createXAxis = function() {
      var datum, xAxis, xValues, _i, _len, _ref;
      xValues = new Array;
      _ref = this.binnedData;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        datum = _ref[_i];
        xValues.push(datum.x);
      }
      xAxis = d3.svg.axis().scale(this.x).orient('bottom').tickValues(xValues).tickFormat(d3.format(",.02f"));
      this.svg.append('g').attr('class', "x axis").attr('transform', "translate(0, " + this.graphHeight + ")").call(xAxis);
      return this.svg.append('text').attr('class', 'x label').attr('text-anchor', 'middle').attr('x', this.graphWidth / 2).attr('y', this.graphHeight + 35).text(this.prettyKey(this.variable));
    };

    Histogram.prototype.createYAxis = function() {
      var yAxis;
      yAxis = d3.svg.axis().scale(this.y).orient('left');
      return this.svg.append('g').attr('class', "y axis").attr('transform', "translate(0,0)").call(yAxis);
    };

    Histogram.prototype.binData = function() {
      var _this = this;
      this.values = _.map(this.filteredData, function(datum) {
        return parseFloat(datum[_this.variable]);
      });
      return this.binnedData = d3.layout.histogram()(values);
    };

    Histogram.prototype.createXScale = function(min, max) {
      if (min == null) {
        min = 0;
      }
      if (max == null) {
        max = 0;
      }
      min = min || d3.min(this.values);
      max = max || d3.max(this.values);
      return this.x = d3.scale.linear().domain([min, max]).range([0, this.graphwidth]);
    };

    Histogram.prototype.createYScale = function(max) {
      if (max == null) {
        max = 0;
      }
      max = max || d3.max(this.binnedData, function(d) {
        return d.y;
      });
      return this.y = d3.scale.linear().domain([0, max]).range([this.graphHeight, 0]);
    };

    Histogram.prototype.createGraph = function() {
      var margin;
      if (!this.data.length) {
        return;
      }
      margin = {
        left: 30,
        right: 30,
        top: 40,
        bottom: 30
      };
      this.graphWidth = this.width - margin.left - margin.right;
      this.graphHeight = this.height - margin.top - margin.bottom;
      return this.svg = d3.select("#" + this.channel + " svg").attr('width', this.width).attr('height', this.height).append('g').attr('transform', "translate(" + margin.left + ", " + margin.right + ")");
    };

    Histogram.prototype.drawBars = function() {
      var bar, formatCount;
      formatCount = d3.format(",.0f");
      bar = svg.selectAll(".bar").data(this.binnedData).enter().append('g').attr('class', 'bar').attr('transform', function(d) {
        return "translate(" + (this.x(d.x) - 1) + ", " + (this.y(d.y)) + ")";
      });
      bar.append('rect').attr('x', 1).attr('width', this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x)).attr('height', function(d) {
        return this.graphHeight - this.y(d.y);
      });
      return bar.append('text').attr("dy", ".75em").attr("y", 6).attr("x", (this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x)) / 2).attr("text-anchor", "middle").text(function(d) {
        return formatCount(d.y);
      });
    };

    Histogram.prototype.render = function() {
      this.html(require('../views/histogram')(this.channel));
      this.createGraph();
      return this.html();
    };

    Histogram.prototype.start = function() {
      this.filterData();
      this.binData();
      this.createXScale();
      this.createYScale();
      this.createXAxis();
      this.createYAxis();
      return this.drawBars();
    };

    return Histogram;

  })(BaseController);

  module.exports = Histogram;

}).call(this);
