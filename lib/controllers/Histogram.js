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

      this.createGraph = __bind(this.createGraph, this);
      Histogram.__super__.constructor.apply(this, arguments);
      this.variable = 'extinction_u';
      this.width = 640;
      this.height = 480;
    }

    Histogram.prototype.createGraph = function() {
      var bar, data, datum, formatCount, height, margin, svg, values, width, x, xAxis, xValues, y, yAxis, _i, _len,
        _this = this;
      if (!this.data.length) {
        this.append("<p>No Data</p>");
        return;
      }
      margin = {
        left: 30,
        right: 30,
        top: 30,
        bottom: 40
      };
      width = this.width - margin.left - margin.right;
      height = this.height - margin.top - margin - bottom;
      console.log(height, width);
      formatCount = d3.format(",.0f");
      values = _.map(this.filteredData, function(datum) {
        return parseFloat(datum[_this.variable]);
      });
      data = d3.layout.histogram()(values);
      y = d3.scale.linear().domain([
        0, d3.max(data, function(d) {
          return d.y;
        })
      ]).range([height, 0]);
      x = d3.scale.linear().domain([d3.min(values), d3.max(values)]).range([0, width]);
      xValues = new Array;
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        datum = data[_i];
        xValues.push(datum.x);
      }
      xAxis = d3.svg.axis().scale(x).orient('bottom').tickValues(xValues).tickFormat(d3.format(",.02f"));
      yAxis = d3.svg.axis().scale(y).orient('left');
      svg = d3.select("#" + this.channel + " svg").attr('width', this.width).attr('height', this.height).append('g').attr('transform', "translate(" + margin.left + ", " + margin.right + ")");
      bar = svg.selectAll(".bar").data(data).enter().append('g').attr('class', 'bar').attr('transform', function(d) {
        return "translate(" + (x(d.x)) + ", " + (y(d.y)) + ")";
      });
      bar.append('rect').attr('x', 1).attr('width', x(data[1].x) - x(data[0].x)).attr('height', function(d) {
        return height - y(d.y);
      });
      bar.append('text').attr("dy", ".75em").attr("y", 6).attr("x", (x(data[1].x) - x(data[0].x)) / 2).attr("text-anchor", "middle").text(function(d) {
        return formatCount(d.y);
      });
      svg.append('g').attr('class', "x axis").attr('transform', "translate(0, " + height + ")").call(xAxis);
      return svg.append('g').attr('class', "y axis").attr('transform', "translate(0,0)").call(yAxis);
    };

    Histogram.prototype.render = function() {
      return this.html(require('../views/histogram')(this.channel));
    };

    Histogram.prototype.start = function() {
      this.filterData();
      return this.createGraph();
    };

    return Histogram;

  })(BaseController);

  module.exports = Histogram;

}).call(this);
