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
    @opts.spectrum = @opts.spectrum or 'visible'
    @createSky(@opts.spectrum)
    @plotObjects() 
    @setupMap()

  setupMap: =>
    zoom = @opts.zoom or 5
    lng = @opts.center_lng or 180
    lat = @opts.center_lat or 0
    @map.setView([lat, lng], zoom)

    @map.on 'zoomend', (e) =>
      @settings
        zoom: @map.getZoom()

    @map.on 'moveend', (e) =>
      center = @map.getCenter()
      @settings
        center_lat: center.lat
        center_lng: center.lng

      bounds = @map.getBounds()
      console.log bounds
      {_northEast: {lat, lng}, _southWest: {lat, lng} = bounds
      console.log _northEast
      #selection = _(@opts.data).chain().filter((d) -> 
    
  createSky: (spectrum) =>
    unless @map
      @map = L.map(@selector.slice(1), Mapper.mapOptions)


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
    coords = [subject.dec, subject.ra - 180]
    options = 
      icon = new L.icon
        iconSize: [25, 41]
        iconAnchor: [13, 41]
        iconUrl: "marker-icon.png"
 
    selectedOptions = 
      icon =  new L.icon
        iconSize: [25, 41]
        iconAnchor: [13, 41]
        iconUrl: "marker-icon.png"
  
    if subject.uid in @opts.selectedIds
      circle = new L.marker(coords, selectedOptions)
    else
      circle = new L.marker(coords, options)
    circle.uid = subject.uid
    circle.addTo(@map)
    @circles.push circle

  plotObjects: =>
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @plotObject subject for subject in @opts.data

window.Ubret.Mapper = Mapper