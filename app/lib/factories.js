GalaxyZooSubject = require('models/GalaxyZooSubject')
Factory = require('rosie/src/rosie')

Factory.define('galaxyZooSubject', GalaxyZooSubject)
  .sequence('id')
  .attr('coords', function() { return [Math.random()*100, Math.random()*100]; })
  .attr('metadata', function() { 
    return {
      magnitude: ((Math.random()*20)+10),
      distance: ((Math.random()*10000)+100)
    };
  })
  .attr('location', { standard: "image/120341241.jpg", thumbnail: "image/120341241-thumb.jpg", inverted: "image/120341241-invert.jpg", fitts: "iamge/120341241.fitts" });

module.exports = Factory