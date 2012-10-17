(function() {
  var BaseController, WWT, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require('./BaseController');

  _ = require('underscore/underscore');

  WWT = (function(_super) {

    __extends(WWT, _super);

    WWT.prototype.name = "WWT";

    function WWT() {
      this.render = __bind(this.render, this);
      WWT.__super__.constructor.apply(this, arguments);
      console.log('WWT');
      this.subscribe(this.subChannel, this.process);
    }

    WWT.prototype.render = function() {
      return this.html(require('../views/wwt')({
        index: this.index
      }));
    };

    return WWT;

  })(BaseController);

  module.exports = WWT;

}).call(this);
