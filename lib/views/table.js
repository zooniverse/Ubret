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
      var filter, i, j, k, key, len, len1, len2, ref, ref1, ref2, subject;
    
      __out.push('<form>\n  <label>Filter Data: <input type="text" name="filter"></label>\n  <button type="submit">Filter</button>\n</form>\n<ul class="filters">\n');
    
      if (this.filters.length) {
        __out.push('\n  ');
        ref = this.filters;
        for (i = 0, len = ref.length; i < len; i++) {
          filter = ref[i];
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
        __out.push('\n        <th>Zooniverse ID <a class="delete">X</a></th>\n        ');
        ref1 = this.keys;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          key = ref1[j];
          __out.push('\n          <th data-key="');
          __out.push(key);
          __out.push('">');
          __out.push(__sanitize(this.prettyKey(key)));
          __out.push(' <a class="delete">X</a></th>\n        ');
        }
        __out.push('\n      ');
      }
    
      __out.push('\n    </tr>\n  </thead>\n  <tbody>\n    ');
    
      if (this.filteredData.length) {
        __out.push('\n      ');
        ref2 = this.filteredData;
        for (k = 0, len2 = ref2.length; k < len2; k++) {
          subject = ref2[k];
          __out.push('\n        ');
          __out.push(this.tableRow({
            subject: subject,
            keys: this.keys
          }));
          __out.push('\n      ');
        }
        __out.push('\n    ');
      }
    
      __out.push('\n  </tbody>\n</table>');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
}