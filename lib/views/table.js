module.exports = function(__obj) {
  if (!__obj) __obj = {};
  var __out = [], __capture = function(callback) {
    var out = __out, result;
    __out = [];
    callback.call(this);
    result = __out.join('');
    __out = out;
    return __safe(result);
  }, __sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (typeof value !== 'undefined' && value != null) {
      return __escape(value);
    } else {
      return '';
    }
  }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
  __safe = __obj.safe = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else {
      if (!(typeof value !== 'undefined' && value != null)) value = '';
      var result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };
  if (!__escape) {
    __escape = __obj.escape = function(value) {
      return ('' + value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
  }
  (function() {
    (function() {
      var filter, key, subject, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    
      __out.push('<form>\n  <label>Filter Data: <input type="text" name="filter" /></label>\n  <button type="submit">Filter</button>\n</form>\n<ul class="filters">\n');
    
      if (this.filters.length) {
        __out.push('\n  ');
        _ref = this.filters;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          filter = _ref[_i];
          __out.push('\n    <li>');
          __out.push(filter.text);
          __out.push(' <div data-id="');
          __out.push(filter.id);
          __out.push('" class="remove_filter">X</div></li>\n  ');
        }
        __out.push('\n');
      }
    
      __out.push('\n</ul>\n<table>\n  <thead>\n    <tr>\n      ');
    
      if (this.keys.length && this.data.length) {
        __out.push('\n        <th>Zooniverse ID <a class="delete">X</a></th>\n      ');
        _ref1 = this.keys;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          key = _ref1[_j];
          __out.push('\n        <th>');
          __out.push(__sanitize(this.prettyKey(key)));
          __out.push(' <a class="delete">X</a></th>\n      ');
        }
        __out.push('\n      ');
      }
    
      __out.push('\n    </tr>\n  </thead>\n  <tbody>\n    ');
    
      if (this.filteredData.length) {
        __out.push('\n    ');
        _ref2 = this.filteredData;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          subject = _ref2[_k];
          __out.push('\n      ');
          __out.push(this.requireTemplate('views/table_row', {
            subject: subject,
            keys: this.keys
          }));
          __out.push('\n    ');
        }
        __out.push('\n    ');
      }
    
      __out.push('\n  </tbody>\n</table>');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
}