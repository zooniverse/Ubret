(function() {
  var BaseController, Graph,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  Graph = (function(_super) {

    __extends(Graph, _super);

    function Graph() {
      this.createGraph = __bind(this.createGraph, this);

      this.createYScale = __bind(this.createYScale, this);

      this.createXScale = __bind(this.createXScale, this);

      this.createYAxis = __bind(this.createYAxis, this);

      this.createXAxis = __bind(this.createXAxis, this);
      Graph.__super__.constructor.apply(this, arguments);
    }

    Graph.prototype.createXAxis = function(ticks, label) {
      var xAxis;
      if (ticks == null) {
        ticks = [];
      }
      if (label == null) {
        label = '';
      }
      xAxis = d3.svg.axis().scale(this.x).orient('bottom').tickFormat(d3.format(",.02f"));
      if (ticks.length !== 0) {
        xAxis.tickValues(ticks);
      }
      this.svg.append('g').attr('class', "x axis").attr('transform', "translate(0, " + this.graphHeight + ")").call(xAxis);
      if (label !== '') {
        return this.svg.append('text').attr('class', 'x label').attr('text-anchor', 'middle').attr('x', this.graphWidth / 2).attr('y', this.graphHeight + 35).text(this.prettyKey(label));
      }
    };

    Graph.prototype.createYAxis = function(ticks, label, format) {
      var yAxis;
      if (ticks == null) {
        ticks = [];
      }
      if (label == null) {
        label = '';
      }
      if (format == null) {
        format = '';
      }
      yAxis = d3.svg.axis().scale(this.y).orient('left');
      if (ticks.length !== 0) {
        yAxis.tickValues(ticks);
      }
      if (typeof format === 'function') {
        yAxis.tickFormat(format);
      }
      this.svg.append('g').attr('class', "y axis").attr('transform', "translate(0,0)").call(yAxis);
      if (label !== '') {
        return this.svg.append('text').attr('class', 'y label').attr('text-anchor', 'middle').attr('x', 0).attr('y', this.graphHeight / 2).text(this.prettyKey(label));
      }
    };

    Graph.prototype.createXScale = function(min, max) {
      if (min == null) {
        min = 0;
      }
      if (max == null) {
        max = 0;
      }
      this.x = d3.scale.linear().domain([min, max]).range([0, this.graphWidth]);
      return console.log(this.x);
    };

    Graph.prototype.createYScale = function(min, max) {
      if (min == null) {
        min = 0;
      }
      if (max == null) {
        max = 0;
      }
      return this.y = d3.scale.linear().domain([min, max]).range([this.graphHeight, 0]);
    };

    Graph.prototype.createGraph = function() {
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

    return Graph;

  })(BaseController);

  module.exports = Graph;

}).call(this);
