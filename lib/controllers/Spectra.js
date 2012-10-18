(function() {
  var BaseController, Spectra, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  Spectra = (function(_super) {

    __extends(Spectra, _super);

    Spectra.prototype.name = "Spectra";

    function Spectra() {
      this.plot = __bind(this.plot, this);

      this.zoom = __bind(this.zoom, this);

      this.render = __bind(this.render, this);
      Spectra.__super__.constructor.apply(this, arguments);
      console.log('Spectra');
      this.subscribe(this.subChannel, this.process);
      this.bind('data-received', this.plot);
    }

    Spectra.prototype.render = function() {
      console.log("index", this.index);
      return this.html(require('../views/spectra')({
        index: this.index
      }));
    };

    Spectra.prototype.zoom = function() {
      this.svg.select(".x.axis").call(this.xAxis);
      this.svg.select(".y.axis").call(this.yAxis);
      this.svg.select("path.fluxes").attr("d", this.fluxLine);
      return this.svg.select("path.best-fit").attr("d", this.bestFitLine);
    };

    Spectra.prototype.plot = function() {
      var bestFit, fluxes, height, margin, wavelengths, width, x, y,
        _this = this;
      wavelengths = this.data[0].wavelengths;
      fluxes = this.data[0].flux;
      bestFit = this.data[0].best_fit;
      margin = {
        top: 14,
        right: 10,
        bottom: 14,
        left: 10
      };
      width = 370 - margin.left - margin.right;
      height = 200 - margin.top - margin.bottom;
      x = d3.scale.linear().range([0, width]).domain(d3.extent(wavelengths));
      y = d3.scale.linear().range([0, height]).domain(d3.extent(fluxes));
      x.ticks(8);
      this.xAxis = d3.svg.axis().scale(x).orient("bottom");
      this.yAxis = d3.svg.axis().scale(y).orient("left");
      this.fluxLine = d3.svg.line().x(function(d, i) {
        return x(wavelengths[i]);
      }).y(function(d, i) {
        return y(d);
      });
      this.bestFitLine = d3.svg.line().x(function(d, i) {
        return x(wavelengths[i]);
      }).y(function(d, i) {
        return y(d);
      });
      this.svg = d3.select("#spectra-" + this.index).append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', "translate(" + margin.left + ", " + margin.top + ")").call(d3.behavior.zoom().x(x).y(y).scaleExtent([1, 8]).on("zoom", this.zoom));
      this.svg.append("area").attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom);
      this.svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + height + ")").call(this.xAxis);
      this.svg.append("g").attr("class", "y axis").call(this.yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Flux (1E-17 erg/cm^2/s/Ang)");
      this.svg.append("path").datum(fluxes).attr("class", "line fluxes").attr("d", this.fluxLine);
      return this.svg.append("path").datum(bestFit).attr("class", "line best-fit").attr("d", this.bestFitLine);
    };

    return Spectra;

  })(BaseController);

  module.exports = Spectra;

}).call(this);
