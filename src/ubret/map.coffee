class Mapper extends Ubret.BaseTool
  name: 'Map'

  # Set the default image path for Leaflet
  L.Icon.Default.imagePath = '/images'

  default_icon: new L.icon {
      className: 'default_icon'
      iconUrl: '/images/marker-icon.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]
    }

  selected_icon: new L.icon {
      className: 'selected_icon'
      iconUrl: '/images/marker-icon-orange.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]
    }

  constructor: (selector) ->
    super 
    @circles = []
    @limit = @limit or 30

  start: =>
    @createSky(@opts.spectrum)
    @plotObjects() 
    
  createSky: (spectrum) =>
    unless @map
      zoom = @opts.zoom or 5
      @map = L.map(@selector.slice(1), Mapper.mapOptions).setView([0, 180], zoom)

      @map.on 'zoomend', (e) =>
        @settings
          zoom: @map.getZoom()


    @layer = L.tileLayer("/images/tiles/#{spectrum}/" + '#{tilename}.jpg',
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
      return "/images/tiles/#{spectrum}/#{url.src}.jpg"

    @layer.addTo @map
  
  plotObject: (subject, options) =>
    coords = [subject.dec, subject.ra]
    options = 
      icon = new L.icon {
          iconSize: [25, 41]
          iconAnchor: [13, 41]
        }
    
    circle = new L.marker(coords, options)
    circle.uid = subject.uid
    
    circle.addTo(@map)
      # .bindPopup('etc')
      # .openPopup()

    @circles.push circle

  plotObjects: =>
    console.log 'plotting objects'
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @plotObject subject for subject in @opts.data

    latlng = new L.LatLng(@opts.data[0].dec, @opts.data[0].ra)
    @map.panTo latlng
  
window.Ubret.Mapper = Mapper