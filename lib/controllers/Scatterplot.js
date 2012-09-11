(function() {
  var BaseController, Scatterplot, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('controllers/BaseController');

  _ = require('underscore/underscore');

  Scatterplot = (function(_super) {

    __extends(Scatterplot, _super);

    function Scatterplot() {
      this.select = __bind(this.select, this);

      this.render = __bind(this.render, this);

      this.start = __bind(this.start, this);

      this.tooltipDisplay = __bind(this.tooltipDisplay, this);
      Scatterplot.__super__.constructor.apply(this, arguments);
      this.xAxisKey = 'ra';
      this.yAxisKey = 'dec';
      this.createGraph();
    }

    Scatterplot.prototype.name = "Scatterplot";

    Scatterplot.prototype.keys = [];

    Scatterplot.prototype.createGraph = function() {
      this.graph = nv.models.scatterChart().showLegend(false).tooltipXContent(null).tooltipYContent(null).tooltipContent(this.tooltipDisplay).color(d3.scale.category10().range());
      return this.graph.scatter.id(this.channel);
    };

    Scatterplot.prototype.tooltipDisplay = function(series, x, y, object, chart) {
      var datum, point, xAxis, yAxis;
      point = object.point;
      datum = _.find(this.data, function(datum) {
        return datum.zooniverse_id === point.zooniverse_id;
      });
      this.publish([
        {
          message: 'selected',
          item_id: point.zooniverse_id
        }
      ]);
      xAxis = this.xAxisKey;
      yAxis = this.yAxisKey;
      return require('../views/scatterplot_tooltip')({
        datum: datum,
        xAxis: xAxis,
        yAxis: yAxis
      });
    };

    Scatterplot.prototype.start = function() {
      this.filterData();
      this.addData();
      this.addFieldsToAxes();
      return this.addAxis();
    };

    Scatterplot.prototype.addFieldsToAxes = function() {
      var key, options, _i, _len, _ref,
        _this = this;
      this.extractKeys(this.data[0]);
      options = "";
      _ref = this.keys;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        options += "<option value='" + key + "'>" + (this.prettyKey(key)) + "</option>";
      }
      this.el.find('.axis_controls').html("      <select class='x-axis'>        " + options + "      </select>      <select class='y-axis'>        " + options + "      </select>    ");
      $("#" + this.channel + " .x-axis").change(function(e) {
        _this.xAxisKey = e.currentTarget.value;
        _this.graph.xAxis.axisLabel(_this.xAxisKey);
        return _this.addData();
      });
      return $("#" + this.channel + " .y-axis").change(function(e) {
        _this.yAxisKey = e.currentTarget.value;
        _this.graph.yAxis.axisLabel(_this.yAxisKey);
        return _this.addData();
      });
    };

    Scatterplot.prototype.addData = function(options) {
      var subject, _i, _len, _ref;
      options = {
        size: 1,
        shape: 'circle'
      };
      this.series = [
        {
          key: "Group",
          values: []
        }
      ];
      if (this.filteredData) {
        _ref = this.filteredData;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subject = _ref[_i];
          this.series[0].values.push({
            x: subject[this.xAxisKey],
            y: subject[this.yAxisKey],
            size: options.size,
            shape: options.shape,
            zooniverse_id: subject.zooniverse_id
          });
        }
      }
      d3.select("#" + this.channel + " svg").datum(this.series).transition().duration(500).call(this.graph);
      return nv.utils.windowResize(this.graph.update);
    };

    Scatterplot.prototype.addAxis = function(options) {
      options = {
        xAxisFormat: '10f',
        yAxisFormat: '10f'
      };
      this.graph.xAxis.axisLabel(this.xAxisKey).tickFormat(d3.format(options.xAxisFormat));
      return this.graph.yAxis.axisLabel(this.yAxisKey).tickFormat(d3.format(options.yAxisFormat));
    };

    Scatterplot.prototype.render = function() {
      return this.html(require('../views/scatterplot')(this));
    };

    Scatterplot.prototype.select = function(itemId) {
      var item, itemIndex;
      d3.select(this.point).classed("hover", false);
      item = _.find(this.series[0].values, function(value) {
        return value.zooniverse_id === itemId;
      });
      itemIndex = _.indexOf(this.series[0].values, item);
      this.point = ".nv-chart-" + this.channel + " .nv-series-0 .nv-point-" + itemIndex;
      d3.select(this.point).classed("hover", true);
      return this.publish([
        {
          message: "selected",
          item_id: itemId
        }
      ]);
    };

    return Scatterplot;

  })(BaseController);

  module.exports = Scatterplot;

}).call(this);
