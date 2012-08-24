GalaxyZooSubject = require('models/GalaxyZooSubject')
Factory = require('rosie/src/rosie')

Factory.define('galaxyZooSubject', GalaxyZooSubject)
  .sequence('id')
  .attr('ra', function() { return Math.random()*100; })
  .attr('dec', function() { return Math.random()*100; })
  .attr('magnitude', function() { return (Math.random()*20)+10; })
  .attr('images', { standard: "image/120341241.jpg", thumbnail: "image/120341241-thumb.jpg", inverted: "image/120341241-invert.jpg", fitts: "iamge/120341241.fitts" });

module.exports = Factory