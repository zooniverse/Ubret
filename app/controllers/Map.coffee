Spine = require('spine')

class Map extends Spine.Controller
  
  constructor: ->
    super
    
    @html require('views/map')()
    @createSky()
  
  createSky: =>
    map = L.map("sky").setView([0, 180], 2)
    layer = L.tileLayer('http://s3.amazonaws.com/chromoscope-photopic/#{tilename}.jpg',
      maxZoom: 18
    )
    layer.getTileUrl = (tilePoint) ->
      zoom = @_getZoomForUrl()
      convertTileUrl = (x, y, s, zoom) ->
        pixels = Math.pow(2, zoom)
        d = (x + pixels) % (pixels)
        e = (y + pixels) % (pixels)
        f = "t"
        g = 0

        while g < zoom
          pixels = pixels / 2
          if e < pixels
            if d < pixels
              f += "q"
            else
              f += "r"
              d -= pixels
          else
            if d < pixels
              f += "t"
              e -= pixels
            else
              f += "s"
              d -= pixels
              e -= pixels
          g++
        x: x
        y: y
        src: f
        s: s

      url = convertTileUrl(tilePoint.x, tilePoint.y, 1, zoom)
      "http://s3.amazonaws.com/chromoscope-photopic/" + url.src + ".jpg"

    layer.addTo map
    
module.exports = Map