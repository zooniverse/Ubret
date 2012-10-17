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
      this.render = __bind(this.render, this);
      Spectra.__super__.constructor.apply(this, arguments);
      console.log('Spectra');
      this.subscribe(this.subChannel, this.process);
    }

    Spectra.prototype.render = function() {
      console.log("index", this.index);
      return this.html(require('../views/spectra')({
        index: this.index
      }));
    };

    return Spectra;

  })(BaseController);

  module.exports = Spectra;

}).call(this);
