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

    Spectra.prototype.plot = function() {
      var fluxes, height, line, margin, svg, wavelengths, width, x, xAxis, y, yAxis;
      console.log('wavelength versus flux', this.data[0].wavelengths, this.data[0].flux);
      wavelengths = this.data[0].wavelengths;
      fluxes = this.data[0].flux;
      margin = {
        top: 14,
        right: 10,
        bottom: 14,
        left: 10
      };
      width = 370 - margin.left - margin.right;
      height = 200 - margin.top - margin.bottom;
      x = d3.scale.linear().range([0, width]);
      y = d3.scale.linear().range([0, height]);
      xAxis = d3.svg.axis().scale(x).orient("bottom");
      yAxis = d3.svg.axis().scale(y).orient("left");
      line = d3.svg.line().x(function(d, i) {
        return x(wavelengths[i]);
      }).y(function(d, i) {
        return y(fluxes[i]);
      });
      svg = d3.select("#spectra-" + this.index).append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', "translate(" + margin.left + ", " + margin.top + ")");
      x.domain(d3.extent(wavelengths));
      y.domain(d3.extent(fluxes));
      console.log('x', x.domain);
      console.log('y', y.domain);
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + height + ")").call(xAxis);
      svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Flux");
      return svg.append("path").datum(fluxes).attr("class", "line").attr("d", line);
    };

    return Spectra;

  })(BaseController);

  module.exports = Spectra;

}).call(this);
