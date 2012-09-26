(function() {
  var Graph, Scatterplot, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Graph = require('./Graph');

  _ = require('underscore/underscore');

  Scatterplot = (function(_super) {

    __extends(Scatterplot, _super);

    function Scatterplot() {
      this.start = __bind(this.start, this);

      this.calculatTicks = __bind(this.calculatTicks, this);

      this.createYAxis = __bind(this.createYAxis, this);

      this.createXAxis = __bind(this.createXAxis, this);

      this.drawPoints = __bind(this.drawPoints, this);

      this.buildCoordinates = __bind(this.buildCoordinates, this);

      this.render = __bind(this.render, this);
      Scatterplot.__super__.constructor.apply(this, arguments);
      this.xAxisKey = this.xAxisKey || 'ra';
      this.yAxisKey = this.yAxisKey || 'dec';
      this.options = {
        xFormat: '',
        yFormat: ''
      };
    }

    Scatterplot.prototype.name = "Scatterplot";

    Scatterplot.prototype.render = function() {
      return this.html(require('../views/scatterplot')(this));
    };

    Scatterplot.prototype.buildCoordinates = function() {
      var _this = this;
      return this.coordinates = _.map(this.filteredData, function(datum) {
        return {
          x: datum[_this.xAxisKey],
          y: datum[_this.yAxisKey]
        };
      });
    };

    Scatterplot.prototype.drawPoints = function() {
      var point,
        _this = this;
      point = this.svg.selectAll('.bar').data(this.coordinates).enter().append('g').attr('class', 'point').attr('transform', function(d) {
        return "translate(" + (_this.x(d.x)) + ", " + (_this.y(d.y)) + ")";
      });
      return point.append('circle').attr('r', 2);
    };

    Scatterplot.prototype.createXAxis = function(label, format) {
      var ticks;
      ticks = this.calculateTicks(this.x);
      return Scatterplot.__super__.createXAxis.call(this, ticks, label, format);
    };

    Scatterplot.prototype.createYAxis = function(label, format) {
      var ticks;
      ticks = this.calculateTicks(this.y);
      return Scatterplot.__super__.createYAxis.call(this, ticks, label, format);
    };

    Scatterplot.prototype.calculatTicks = function(axis) {
      var max, min, numTicks, tick, tickWidth, ticks;
      min = _.first(axis.domain());
      max = _.last(axis.domain());
      ticks = [min, max];
      numTicks = Math.floor(this.graphWidth / 50);
      tickWidth = (max - min) / numTicks;
      tick = min + tickWidth;
      while (tick < max) {
        ticks.push(tick);
        tick = tick + tickWidth;
      }
      return ticks;
    };

    Scatterplot.prototype.start = function() {
      this.filterData();
      this.buildCoordinates();
      this.createGraph();
      this.createXScale(d3.min(this.coordinates, function(d) {
        return d.x;
      }), d3.max(this.coordinates, function(d) {
        return d.x;
      }));
      this.createYScale(d3.min(this.coordinates, function(d) {
        return d.y;
      }), d3.max(this.coordinates, function(d) {
        return d.y;
      }));
      this.createXAxis(this.xAxisKey, this.options.xFormat);
      this.createYAxis(this.yAxisKey, this.options.yFormat);
      return this.drawPoints();
    };

    return Scatterplot;

  })(Graph);

  module.exports = Scatterplot;

}).call(this);
