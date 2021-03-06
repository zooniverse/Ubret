exports.config = 
  paths:
    watched: ["libubret", "tools", "test", "vendor"]

  modules:
    definition: (path, data) ->
      if (path is "public/js/libubret.js")
        """
        (function() {
          "use strict";
          var noconflict;
          if (this.U)
            noconflict = this.U;

          this.U = {}
          this.U.noconflict = noconflict;

        }).call(this);
        """
      else if (path is"public/js/tools.js")
        """
          (function(/*! Brunch !*/) {
            'use strict';

            var globals = typeof window !== 'undefined' ? window : global;
            if (typeof globals.require === 'function') return;

            var modules = {};
            var cache = {};

            var has = function(object, name) {
              return ({}).hasOwnProperty.call(object, name);
            };

            var expand = function(root, name) {
              var results = [], parts, part;
              if (/^\\.\\.?(\\/|$)/.test(name)) {
                parts = [root, name].join('/').split('/');
              } else {
                parts = name.split('/');
              }
              for (var i = 0, length = parts.length; i < length; i++) {
                part = parts[i];
                if (part === '..') {
                  results.pop();
                } else if (part !== '.' && part !== '') {
                  results.push(part);
                }
              }
              return results.join('/');
            };

            var dirname = function(path) {
              return path.split('/').slice(0, -1).join('/');
            };

            var localRequire = function(path) {
              return function(name) {
                var dir = dirname(path);
                var absolute = expand(dir, name);
                return globals.require(absolute, path);
              };
            };

            var initModule = function(name, definition) {
              var module = {id: name, exports: {}};
              definition(module.exports, localRequire(name), module);
              var exports = cache[name] = module.exports;
              return exports;
            };

            var require = function(name, loaderPath) {
              var path = expand(name, '.');
              if (loaderPath == null) loaderPath = '/';

              if (has(cache, path)) return cache[path];
              if (has(modules, path)) return initModule(path, modules[path]);

              var dirIndex = expand(path, './index');
              if (has(cache, dirIndex)) return cache[dirIndex];
              if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

              throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
            };

            var define = function(bundle, fn) {
              if (typeof bundle === 'object') {
                for (var key in bundle) {
                  if (has(bundle, key)) {
                    modules[key] = bundle[key];
                  }
                }
              } else {
                modules[bundle] = fn;
              }
            };

            var list = function() {
              var result = [];
              for (var item in modules) {
                if (has(modules, item)) {
                  result.push(item);
                }
              }
              return result;
            };

            globals.require = require;
            globals.require.define = define;
            globals.require.register = define;
            globals.require.list = list;
            globals.require.brunch = true;
          })();
        """
      else
        ""

    wrapper: (path, data) ->
      if (path.split('/')[0] is 'tools')
        """
        require.define({"#{path.split('.')[0]}": function(exports, require, module) {
          #{data}
        }});\n\n
        """
      else
        """
        (function() {
          #{data}
        }).call(this);\n\n
        """
    
  files:
    javascripts:
      joinTo:
        'js/libubret.js' : /^libubret/
        'js/vendor.js' : /^(bower_components|vendor)/
        'js/tools.js' : /^tools/
        'js/test.js' : /^test(\/|\\)(?!vendor)/

    stylesheets:
      joinTo: 
        'css/tools.css': /^tools/
        'css/vendor.css': /^(bower_components|vendor)/

    templates:
      joinTo:
        'js/tools.js' : /^tools/