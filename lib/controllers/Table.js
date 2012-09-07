(function() {
  var BaseController, Table, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseController = require("./BaseController");

  _ = require("underscore/underscore");

  Table = (function(_super) {

    __extends(Table, _super);

    Table.prototype.elements = {
      'input[name="filter"]': 'filter'
    };

    Table.prototype.events = {
      'click .subject': 'selection',
      'click .delete': 'removeColumn',
      'click .remove_filter': 'onRemoveFilter',
      submit: 'onSubmit'
    };

    function Table() {
      this.processFilterArray = __bind(this.processFilterArray, this);

      this.parseFilter = __bind(this.parseFilter, this);

      this.onSubmit = __bind(this.onSubmit, this);

      this.onRemoveFilter = __bind(this.onRemoveFilter, this);

      this.removeColumn = __bind(this.removeColumn, this);

      this.select = __bind(this.select, this);

      this.selection = __bind(this.selection, this);

      this.render = __bind(this.render, this);

      this.start = __bind(this.start, this);
      Table.__super__.constructor.apply(this, arguments);
    }

    Table.prototype.name = "Table";

    Table.prototype.start = function() {
      return this.render();
    };

    Table.prototype.render = function() {
      this.keys = new Array;
      this.extractKeys(this.data[0]);
      this.filterData();
      return this.html(require('views/table')(this));
    };

    Table.prototype.selection = function(e) {
      if (this.selected) {
        this.selected.removeClass('selected');
      }
      this.selected = this.el.find(e.currentTarget);
      this.selected.addClass('selected');
      return this.publish([
        {
          message: "selected",
          item_id: this.selected.attr('data-id')
        }
      ]);
    };

    Table.prototype.select = function(itemId) {
      if (this.selected) {
        this.selected.removeClass('selected');
      }
      this.selected = this.el.find("tr.subject[data-id='" + itemId + "']");
      this.selected.addClass('selected');
      return this.publish([
        {
          message: "selected",
          item_id: itemId
        }
      ]);
    };

    Table.prototype.removeColumn = function(e) {
      var index, target;
      target = $(e.currentTarget);
      index = target.closest('th').prevAll('th').length;
      return target.parents('table').find('tr').each(function() {
        return $(this).find("td:eq(" + index + "), th:eq(" + index + ")").remove();
      });
    };

    Table.prototype.onRemoveFilter = function(e) {
      var filter;
      filter = (function() {
        var _i, _len, _ref, _results;
        _ref = this.filters;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          filter = _ref[_i];
          if (filter.id === $(e.currentTarget).data('id')) {
            _results.push(filter);
          }
        }
        return _results;
      }).call(this);
      return this.removeFilter(filter);
    };

    Table.prototype.onSubmit = function(e) {
      e.preventDefault();
      return this.addFilter(this.parseFilter(this.filter.val()));
    };

    Table.prototype.parseFilter = function(string) {
      var filter, filterFunc, filterID, tokens;
      tokens = string.split(" ");
      filter = this.processFilterArray(tokens);
      filter = "return" + filter.join(" ");
      filterFunc = new Function("item", filter);
      filterID = _.uniqueId("filter_");
      return {
        id: filterID,
        text: string,
        func: filterFunc
      };
    };

    Table.prototype.processFilterArray = function(tokens, filters) {
      var nextAnd, nextOr, predicate;
      if (filters == null) {
        filters = [];
      }
      nextOr = _.indexOf(tokens, "or");
      nextAnd = _.indexOf(tokens, "and");
      if (((nextOr < nextAnd) || (nextAnd === -1)) && (nextOr !== -1)) {
        predicate = tokens.splice(0, nextOr);
        filters.push(this.parsePredicate(predicate));
        filters.push("||");
      } else if (((nextAnd < nextOr) || (nextOr === -1)) && (nextAnd !== -1)) {
        predicate = tokens.splice(0, nextAnd);
        filters.push(this.parsePredicate(predicate));
        filters.push("&&");
      } else {
        predicate = tokens;
        filters.push(this.parsePredicate(predicate));
      }
      if (predicate !== tokens) {
        return this.processFilterArray(tokens.splice(1), filters);
      } else {
        return filters;
      }
    };

    Table.prototype.parsePredicate = function(predicate) {
      var comparison, comparisonIndex, field, fieldEnd, isIndex, limiter, operator;
      limiter = _.last(predicate);
      comparison = _.find(predicate, function(item) {
        return item === 'equal' || item === 'equals' || item === 'greater' || item === 'less' || item === 'not' || item === '=' || item === '>' || item === '<' || item === '!=' || item === '<=' || item === '>=';
      });
      isIndex = _.indexOf(predicate, "is");
      comparisonIndex = _.indexOf(predicate, comparison);
      fieldEnd = isIndex < comparisonIndex ? isIndex : comparisonIndex;
      field = predicate.splice(0, fieldEnd).join(" ");
      switch (comparison) {
        case 'equal':
          operator = '==';
          break;
        case 'equals':
          operator = '==';
          break;
        case 'greater':
          operator = '>';
          break;
        case 'less':
          operator = '<';
          break;
        case 'not':
          operator = '!=';
          break;
        case '=':
          operator = '==';
          break;
        default:
          operator = comparison;
      }
      return "(item['" + (this.uglifyKey(field)) + "'] " + operator + " " + (parseFloat(limiter)) + ")";
    };

    return Table;

  })(BaseController);

  module.exports = Table;

}).call(this);
