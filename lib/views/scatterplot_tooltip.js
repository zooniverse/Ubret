(function() {
  this.ecoTemplates || (this.ecoTemplates = {});
  this.ecoTemplates["scatterplot_tooltip"] = function(__obj) {
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
      
        __out.push('<ul>\n  <li>id: ');
      
        __out.push(this.datum.zooniverse_id);
      
        __out.push('</li>\n  <li>');
      
        __out.push(this.xAxis);
      
        __out.push(': ');
      
        __out.push(this.datum[this.xAxis]);
      
        __out.push('</li>\n  <li>');
      
        __out.push(this.yAxis);
      
        __out.push(': ');
      
        __out.push(this.datum[this.yAxis]);
      
        __out.push('</li>\n</ul>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
