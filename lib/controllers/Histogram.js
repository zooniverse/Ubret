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

      this.setVariable = __bind(this.setVariable, this);

      this.render = __bind(this.render, this);

      this.createGraph = __bind(this.createGraph, this);
      Histogram.__super__.constructor.apply(this, arguments);
      this.height = this.height || 480;
      this.width = this.width || 640;
      this.margin = this.margin || {
        left: 40,
        bottom: 40
      };
      this.format = this.format || d3.format(',.02f');
    }

    Histogram.prototype.createGraph = function() {
      var bar, bin, bins, graphHeight, graphWidth, lastBin, lastTick, svg, ticks, x, xAxis, xDomain, y, yAxis, yDomain, _i, _len,
        _this = this;
      if (typeof this.variable === 'undefined') {
        return;
      }
      graphWidth = this.width - this.margin.left;
      graphHeight = this.height - this.margin.bottom;
      svg = d3.select("#" + this.channel + " svg").attr('width', graphWidth).attr('height', graphHeight).append('g').attr('transform', "translate(" + this.margin.left + ", " + this.margin.bottom + ")");
      if (this.filteredData.length !== 0) {
        bins = d3.layout.histogram()(_.map(this.filteredData, function(d) {
          return d[this.variable];
        }));
        xDomain = d3.extent(this.filteredData, function(d) {
          return d[this.variable];
        });
        yDomain = [
          0, d3.max(bin, function(d) {
            return d.y;
          })
        ];
      } else {
        bins = [];
        xDomain = [0, 1];
        yDomain = [0, 1];
      }
      x = d3.scale.linear().domain(xDomain).range([0, graphWidth]);
      y = d3.scale.linear().domain(yDomain).range([graphHeight, 0]);
      xAxis = d3.svg.axis().scale(x).orient('bottom');
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
      yAxis = d3.svg.axis().scale(y).orient('left');
      svg.append('g').attr('class', 'x aixs').attr('transform', "translate(0, " + graphHeight).call(xAxis);
      svg.append('g').attr('class', 'y axis').attr('transform', "translate(0, 0)").call(yAxis);
      svg.append('text').attr('class', 'x label').attr('text-anchor', 'middle').attr('x', graphWidth / 2).attr('y', graphHeight + 35).text(this.prettyKey(label));
      if (bins.length !== 0) {
        bar = svg.selectAll('.bar').transition().duration(700).data(bins).enter().append('g').attr('class', 'bar').attr('transform', function(d) {
          return "translate(" + (_this.x(d.x)) + ", " + (_this.y(d.y) - 1) + ")";
        });
        bar.append('rect').attr('x', 1).attr('width', this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x) - 2).attr('height', function(d) {
          return _this.graphHeight - _this.y(d.y);
        });
        return bar.append('text').attr("dy", ".75em").attr("y", 6).attr("x", (this.x(this.binnedData[1].x) - this.x(this.binnedData[0].x)) / 2).attr("text-anchor", "middle").text(function(d) {
          return formatCount(d.y);
        });
      }
    };

    Histogram.prototype.render = function() {
      return this.html(require('../views/histogram')(this.channel));
    };

    Histogram.prototype.setVariable = function(variable) {
      this.variable = variable;
      return this.createGraph();
    };

    Histogram.prototype.start = function() {
      this.filterData();
      return this.createGraph();
    };

    return Histogram;

  })(BaseController);

  module.exports = Histogram;

}).call(this);
