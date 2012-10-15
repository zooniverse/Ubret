(function() {
  var BaseController, Histogram, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  Histogram = (function(_super) {

    __extends(Histogram, _super);

    function Histogram() {
      this.start = __bind(this.start, this);

      this.setVariable = __bind(this.setVariable, this);

      this.render = __bind(this.render, this);

      this.drawBars = __bind(this.drawBars, this);

      this.createGraph = __bind(this.createGraph, this);
      Histogram.__super__.constructor.apply(this, arguments);
      this.height = this.height || 480;
      this.width = this.width || 640;
      this.margin = this.margin || {
        left: 40,
        top: 20,
        bottom: 40
      };
      this.format = this.format || d3.format(',.02f');
      this.color = this.color || 'teal';
      this.selectionColor = this.color || 'orange';
    }

    Histogram.prototype.name = "Histogram";

    Histogram.prototype.createGraph = function() {
      var bin, binFunction, binRanges, bins, data, lastBin, lastTick, selectedData, ticks, unselectedData, xAxis, xDomain, yAxis, yDomain, _i, _len,
        _this = this;
      if (typeof this.variable === 'undefined') {
        return;
      }
      this.el.find('svg').empty();
      this.graphWidth = this.width - this.margin.left;
      this.graphHeight = this.height - this.margin.top - this.margin.bottom;
      this.formatCount = d3.format(',.0f');
      this.svg = d3.select("#" + this.channel + " svg").attr('width', this.width).attr('height', this.height).append('g').attr('transform', "translate(" + this.margin.left + ", " + this.margin.top + ")");
      if (this.filteredData.length > 1) {
        data = _.map(this.filteredData, function(d) {
          return d[_this.variable];
        });
        data = _.filter(data, function(d) {
          return d !== null;
        });
        bins = d3.layout.histogram()(data);
        xDomain = d3.extent(this.filteredData, function(d) {
          return d[_this.variable];
        });
        yDomain = [
          0, d3.max(bins, function(d) {
            return d.y;
          })
        ];
      } else if (this.filteredData.length === 1) {
        svg.append('text').attr('class', 'data-warning').attr('y', graphHeight / 2).attr('x', graphWidth / 2).attr('text-anchor', 'middle').text('Not Enough Data, Classify More Galaxies!');
        return;
      } else {
        bins = [];
        xDomain = [0, 1];
        yDomain = [0, 1];
      }
      this.x = d3.scale.linear().domain(xDomain).range([0, this.graphWidth]);
      this.y = d3.scale.linear().domain(yDomain).range([this.graphHeight, 0]);
      xAxis = d3.svg.axis().scale(this.x).orient('bottom');
      if (bins.length !== 0) {
        ticks = new Array;
        for (_i = 0, _len = bins.length; _i < _len; _i++) {
          bin = bins[_i];
          ticks.push(bin.x);
        }
        lastBin = _.last(bins);
        lastTick = lastBin.x + lastBin.dx;
        ticks.push(lastTick);
      } else {
        ticks = [0, 0.25, 0.5, 0.75, 1];
      }
      xAxis.tickValues(ticks);
      xAxis.tickFormat(this.format);
      yAxis = d3.svg.axis().scale(this.y).orient('left');
      this.svg.append('g').attr('class', 'x axis').attr('transform', "translate(0, " + this.graphHeight + ")").call(xAxis);
      this.svg.append('g').attr('class', 'y axis').attr('transform', "translate(0, 0)").call(yAxis);
      this.svg.append('text').attr('class', 'x label').attr('text-anchor', 'middle').attr('x', this.graphWidth / 2).attr('y', this.graphHeight + 35).text(this.prettyKey(this.variable));
      if (bins.length !== 0) {
        if (this.selectedData.length !== 0) {
          binRanges = _.map(bins, function(d) {
            return d.x;
          });
          binFunction = d3.layout.histogram().bins(binRanges);
          unselectedData = _.filter(this.filteredData, function(d) {
            return !(__indexOf.call(_this.selectedData, d) >= 0);
          });
          selectedData = _.map(this.selectedData, function(d) {
            return d[_this.variable];
          });
          unselectedData = _.map(unselectedData, function(d) {
            return d[_this.variable];
          });
          if (unselectedData.length > 1) {
            this.drawBars(binFunction(unselectedData), this.color, true);
          }
          if (selectedData.length > 1) {
            return this.drawBars(binFunction(selectedData), this.selectionColor, true, true);
          }
        } else {
          return this.drawBars(bins, this.color);
        }
      }
    };

    Histogram.prototype.drawBars = function(bins, color, halfSize, offset) {
      var bar, width,
        _this = this;
      if (halfSize == null) {
        halfSize = false;
      }
      if (offset == null) {
        offset = false;
      }
      console.log(bins, color, halfSize, offset);
      width = this.x(bins[1].x) - this.x(bins[0].x);
      width = halfSize ? (width / 2) - 1 : width - 2;
      bar = this.svg.selectAll(".bar-" + color).data(bins).enter().append('g').attr('class', 'bar').attr('transform', function(d) {
        if (offset) {
          return "translate(" + (_this.x(d.x) + (width / 2)) + ", " + (_this.y(d.y)) + ")";
        } else {
          return "translate(" + (_this.x(d.x) - 1) + ", " + (_this.y(d.y)) + ")";
        }
      });
      bar.append('rect').attr('x', 1).attr('width', width).attr('height', function(d) {
        return _this.graphHeight - _this.y(d.y);
      }).attr('fill', color);
      return bar.append('text').attr("dy", ".75em").attr("y", 6).attr("x", (this.x(bins[1].x) - this.x(bins[0].x)) / 2).attr("text-anchor", "middle").text(function(d) {
        return _this.formatCount(d.y);
      });
    };

    Histogram.prototype.render = function() {
      return this.html(require('../views/histogram')(this.channel));
    };

    Histogram.prototype.setVariable = function(variable) {
      this.variable = variable;
      return this.createGraph();
    };

    Histogram.prototype.start = function() {
      Histogram.__super__.start.apply(this, arguments);
      return this.createGraph();
    };

    return Histogram;

  })(BaseController);

  module.exports = Histogram;

}).call(this);
