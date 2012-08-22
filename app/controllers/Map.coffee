Spine = require('spine')

class Map extends Spine.Controller
  @mapOptions =
    attributionControl: false
    
  # Set the default image path
  L.Icon.Default.imagePath = 'css/images'
  
  
  constructor: ->
    super
    
    @html require('views/map')()
    @createSky()
    @plotObjects()
    
  createSky: =>
    @map = L.map("sky", Map.mapOptions).setView([0, 180], 2)
    @layer = L.tileLayer('/tiles/#{zoom}/#{tilename}.jpg',
      maxZoom: 7
    )
    @layer.getTileUrl = (tilePoint) ->
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
      return "/tiles/#{zoom}/#{url.src}.jpg"

    @layer.addTo @map
  
  plotObject: (ra, dec) =>
    L.marker([ra, dec]).addTo(@map)
    
  plotObjects: =>
    options =
      color: '#0172E6'
    
    circle = L.circle([0, 0], 500, options).addTo(@map)
    circle.on('click', ( ->
      console.log @
    ))
    
    for subject in @subjects
      coords = subject.coords
      circle = L.circle(coords, 500, options).addTo(@map)
      circle.zooniverse_id = subject.zooniverse_id
      circle.on('click', ( ->
        $('.subject').removeClass('selected')
        $("[data-id=#{@.zooniverse_id}]").addClass('selected')
      ))
      # circle.bindPopup("ra: #{coords[0]}, dec: #{coords[1]}")
  
  
module.exports = Map