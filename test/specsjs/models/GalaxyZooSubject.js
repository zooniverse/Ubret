(function() {
  var require;

  require = window.require;

  describe('GalaxyZooSubject', function() {
    var GalaxyZooSubject;
    GalaxyZooSubject = require('models/GalaxyZooSubject');
    beforeEach(function() {
      return this.galazyZooSubject = GalaxyZooSubject.create();
    });
    return it('should be instantiable', function() {
      return expect(this.galaxyZooSubject).not.toBeNull();
    });
  });

}).call(this);
