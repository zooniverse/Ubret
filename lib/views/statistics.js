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
      var key, stat, _i, _j, _len, _len1, _ref, _ref1;
    
      __out.push('<div class="stats">\n  <select name="key" id="select-key">\n    ');
    
      _ref = this.keys;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        __out.push('\n      ');
        if (key === this.currentKey) {
          __out.push('\n        <option name="key" value="');
          __out.push(key);
          __out.push('" selected>');
          __out.push(key);
          __out.push('</option>\n      ');
        } else {
          __out.push('\n        <option name="key" value="');
          __out.push(key);
          __out.push('">');
          __out.push(key);
          __out.push('</option>\n      ');
        }
        __out.push('\n    ');
      }
    
      __out.push('\n  </select>\n\n  <ul>\n    ');
    
      _ref1 = this.stats;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        stat = _ref1[_j];
        __out.push('\n      <li><label>');
        __out.push(stat.label);
        __out.push(':</label> ');
        __out.push(stat.value);
        __out.push('</li>\n    ');
      }
    
      __out.push('\n  </ul>\n</div>');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
}