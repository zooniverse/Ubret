class Mapper extends Ubret.BaseTool
  name: 'Map'

  # Set the default image path for Leaflet
  L.Icon.Default.imagePath = '/images'

  defaultIcon: new L.icon
      className: 'default_icon'
      iconUrl: '/images/marker-icon.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]

  selectedIcon: new L.icon
      className: 'selected_icon'
      iconUrl: '/images/marker-icon-orange.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]

  constructor: ->
    super 
    @circles = []
    @limit = @limit or 30

  defaults: 
    spectrum: 'visible'
    zoom: 5
    center_lng: 100
    center_lat: 0

  events:
    'selector' : 'createMap'
    'data setting:spectrum' : 'createSky'
    'data' : 'plotObjects'
    'setting:center_lng setting:center_lat setting:zoom' : 'moveTo'

  moveTo: ->
    @map.setView([@opts.center_lat, @opts.center_lng], @opts.zoom) if @map?

  createMap: ->
    @map = L.map(@opts.el, Mapper.mapOptions)
    #@map.on 'zoomend', (e) =>
    #@settings
    #zoom: @map.getZoom()

    #@map.on 'moveend', (e) =>
    #center = @map.getCenter()
    #@settings
    #center_lat: center.lat
    #center_lng: center.lng


    @moveTo()

  createSky: ->
    return unless @map?
    spectrum = @opts.spectrum
    @layer = L.tileLayer("/images/tiles/#{spectrum}/" + '#{tilename}.jpg',
      maxZoom: 7)

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
  
  plotObject: (subject, options) ->
    coords = [subject.dec, subject.ra - 180]
  
    if subject.uid in @opts.selectedIds
      circle = new L.marker(coords, {icon: @selectedIcon})
    else
      circle = new L.marker(coords, {icon: @defaultIcon})
    circle.uid = subject.uid
    circle.addTo(@map)
    @circles.push circle

  plotObjects: ->
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @plotObject subject for subject in @opts.data

window.Ubret.Mapper = Mapper