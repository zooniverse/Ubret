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

  mapOptions: 
    minZoom: 0
    maxZoom: 7
    center: [0, 0]
    zoom: 5

  constructor: ->
    super 
    @circles = []

  events:
    'selector' : 'createMap'
    'height' : 'createMap'
    'width' : 'createMap'
    'data' : 'plotObjects createSky'
    'setting:spectrum' : 'createSky'
    'setting:center_lng' : 'moveTo'
    'setting:center_lat' : 'moveTo'
    'setting:zoom' : 'moveTo'

  moveTo: ->
    return unless @opts.center_lat? and @opts.center_lng? and @opts.zoom?
    @map.setView([@opts.center_lat, @opts.center_lng], @opts.zoom) if @map?

  createMap: ->
    return unless @opts.width? and @opts.height?
    @el.style.height = @opts.height + "px"
    @el.style.width = @opts.width + "px"

    if @map?
      @map.invalidateSize()
    else
      @map = L.map(@el, @mapOptions)
      @map._onResize() # I Should not have to do this Leaflet issue #694
      @map.on 'zoomend', @mapZoom
      @map.on 'moveend', @mapMove

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
    return unless @map?
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @plotObject subject for subject in @preparedData()

  mapZoom: (e) =>
    @settings 
      zoom: @map.getZoom()

  mapMove: (e) =>
   {lat, lng} = @map.getCenter()
   @settings
     center_lat: lat
     center_lng: lng

window.Ubret.Mapper = Mapper