(function() {
  var Histogram, Spine,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Spine = require('spine');

  Histogram = (function(_super) {

    __extends(Histogram, _super);

    function Histogram() {
      Histogram.__super__.constructor.apply(this, arguments);
    }

    return Histogram;

  })(Spine.Controller);

  module.exports = Histogram;

}).call(this);
