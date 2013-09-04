exports.config = 
  files:
    javascripts:
      joinTo:
        'js/libubret.js' : /^app\/libubret/
        'js/vendor.js' : /^(bower_components|vendor)/
        'js/tools.js' : /^app\/tools/
        'js/test.js' : /^test(\/|\\)(?!vendor)/

    stylesheets:
      joinTo: 
        'css/tools.css': /^app\/tools\/style/
        'css/vendor.css': /^(bower_components|vendor)/

    templates:
      joinTo:
        'js/tools.js' : /^app\/tools/