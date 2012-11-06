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
      var key, value, _ref;
    
      if (this.subject) {
        __out.push('\n  ');
        if (this.count > 1) {
          __out.push('\n    <div class="nav">\n      <a class="back">back</a>\n      <a class="next">next</a>\n    </div>\n  ');
        }
        __out.push('\n\n  ');
        if (this.subject.image) {
          __out.push('\n    <img src="');
          __out.push(this.subject.image);
          __out.push('" />\n  ');
        }
        __out.push('\n\n  <ul>\n    <li>id: ');
        __out.push(this.subject.zooniverse_id);
        __out.push('</li>\n    ');
        _ref = this.keys;
        for (key in _ref) {
          value = _ref[key];
          __out.push('\n    <li>');
          __out.push(key);
          __out.push(': ');
          __out.push(typeof this.subject[value] !== 'string' ? this.format(this.subject[value]) : this.subject[value]);
          __out.push(' ');
          __out.push(this.labels[value]);
          __out.push('</li>\n    ');
        }
        __out.push('\n  </ul>\n');
      }
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
}