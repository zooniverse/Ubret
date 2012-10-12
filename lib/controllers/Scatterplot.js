(function() {
  var BaseController, Scatterplot, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  Scatterplot = (function(_super) {

    __extends(Scatterplot, _super);

    function Scatterplot() {
      this.start = __bind(this.start, this);

      this.setYVar = __bind(this.setYVar, this);

      this.setXVar = __bind(this.setXVar, this);

      this.calculateTicks = __bind(this.calculateTicks, this);

      this.drawPoints = __bind(this.drawPoints, this);

      this.drawAxes = __bind(this.drawAxes, this);

      this.createGraph = __bind(this.createGraph, this);

      this.select = __bind(this.select, this);

      this.sendSelection = __bind(this.sendSelection, this);

      this.removeTooltip = __bind(this.removeTooltip, this);

      this.displayTooltip = __bind(this.displayTooltip, this);

      this.render = __bind(this.render, this);
      Scatterplot.__super__.constructor.apply(this, arguments);
      this.height = this.height || 480;
      this.width = this.width || 640;
      this.margin = this.margin || {
        left: 40,
        top: 20,
        bottom: 40
      };
      this.color = this.color || 'teal';
      this.seriesFilters = new Array;
      this.xFormat = this.xFormat || d3.format(',.02f');
      this.yFormat = this.yFormat || d3.format(',.02f');
    }

    Scatterplot.prototype.name = "Scatterplot";

    Scatterplot.prototype.render = function() {
      return this.html(require('../views/scatterplot')(this));
    };

    Scatterplot.prototype.displayTooltip = function(d, i) {
      var left, tooltip, top, xAxis, xAxisVal, yAxis, yAxisVal;
      xAxis = this.prettyKey(this.xAxisKey);
      yAxis = this.prettyKey(this.yAxisKey);
      xAxisVal = this.xFormat(d.x);
      yAxisVal = this.yFormat(d.y);
      top = d3.event.pageY - 50;
      left = d3.event.pageX;
      this.sendSelection(i);
      tooltip = require('../views/scatterplot_tooltip')({
        xAxis: xAxis,
        yAxis: yAxis,
        xAxisVal: xAxisVal,
        yAxisVal: yAxisVal
      });
      this.append(tooltip);
      return this.el.find('.tooltip').offset({
        top: top,
        left: left
      });
    };

    Scatterplot.prototype.removeTooltip = function(d, i) {
      return this.el.find('.tooltip').remove();
    };

    Scatterplot.prototype.sendSelection = function(index) {
      var selectedItem;
      selectedItem = this.filteredData[index];
      return this.publish([
        {
          message: "selected",
          item_id: selectedItem.zooniverse_id
        }
      ]);
    };

    Scatterplot.prototype.select = function(itemId) {
      return _.indexOf(this.filteredData(itemId));
    };

    Scatterplot.prototype.createGraph = function() {
      var graphData;
      if ((typeof this.xAxisKey === 'undefined') && (typeof this.yAxixKey === 'undefined')) {
        return;
      }
      this.el.find('svg').empty();
      this.graphWidth = this.width - this.margin.left;
      this.graphHeight = this.height - this.margin.top - this.margin.bottom;
      this.svg = d3.select("#" + this.channel + " svg").attr('width', this.width).attr('height', this.height).append('g').attr('transform', "translate(" + this.margin.left + ", " + this.margin.top + ")");
      graphData = this.drawAxes();
      return this.drawPoints(graphData, this.color);
    };

    Scatterplot.prototype.drawAxes = function() {
      var data, xAxis, xDomain, yAxis, yDomain,
        _this = this;
      if (this.filteredData.length !== 0) {
        data = _.map(this.filteredData, function(d) {
          return {
            x: d[_this.xAxisKey],
            y: d[_this.yAxisKey]
          };
        });
        xDomain = d3.extent(data, function(d) {
          return d.x;
        });
        yDomain = d3.extent(data, function(d) {
          return d.y;
        });
      } else {
        data = [];
        xDomain = [0, 10];
        yDomain = [0, 10];
      }
      if (typeof this.xAxisKey !== 'undefined') {
        this.x = d3.scale.linear().domain(xDomain).range([0, this.graphWidth]);
        xAxis = d3.svg.axis().scale(this.x).orient('bottom').tickFormat(this.xFormat);
        if (data.length !== 0) {
          xAxis.tickValues(this.calculateTicks(this.x));
        }
        this.svg.append('g').attr('class', 'x axis').attr('transform', "translate(0, " + this.graphHeight + ")").call(xAxis);
        this.svg.append('text').attr('class', 'x label').attr('text-anchor', 'middle').attr('x', this.graphWidth / 2).attr('y', this.graphHeight + 30).text(this.prettyKey(this.xAxisKey));
      }
      if (typeof this.yAxisKey !== 'undefined') {
        this.y = d3.scale.linear().domain(yDomain).range([this.graphHeight, 0]);
        yAxis = d3.svg.axis().scale(this.y).orient('left').tickFormat(this.yFormat);
        if (data.length !== 0) {
          yAxis.tickValues(this.calculateTicks(this.y));
        }
        this.svg.append('g').attr('class', 'y axis').attr('transform', 'translate(0, 0)').call(yAxis);
        this.svg.append('text').attr('class', 'y label').attr('text-anchor', 'middle').attr('y', -40).attr('x', -(this.graphHeight / 2)).attr('transform', "rotate(-90)").text(this.prettyKey(this.yAxisKey));
      }
      return data;
    };

    Scatterplot.prototype.drawPoints = function(data, color) {
      var point;
      if (data.length !== 0) {
        point = this.svg.selectAll('.point').data(data).enter().append('g').attr('class', 'point').attr('transform', function(d) {
          if ((d.x === null) || (d.y === null)) {

          } else {
            return "translate(" + (this.x(d.x)) + ", " + (this.y(d.y)) + ")";
          }
        }).on('mouseover', this.displayTooltip).on('mouseout', this.removeTooltip);
        return point.append('circle').attr('r', 3).attr('id', function(d) {
          return d.x;
        }).attr('fill', color);
      }
    };

    Scatterplot.prototype.calculateTicks = function(axis) {
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

    Scatterplot.prototype.setXVar = function(variable) {
      this.xAxisKey = variable;
      return this.createGraph();
    };

    Scatterplot.prototype.setYVar = function(variable) {
      this.yAxisKey = variable;
      return this.createGraph();
    };

    Scatterplot.prototype.start = function() {
      this.filterData();
      return this.createGraph();
    };

    return Scatterplot;

  })(BaseController);

  module.exports = Scatterplot;

}).call(this);
