BaseTool = window.Ubret.BaseTool or require('./base_tool')

class Map extends BaseTool
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

  constructor: (opts) ->
    super opts
    @circles = []
    @limit = @limit or 30

  start: =>
    if @map
      @map.invalidateSize()
    else
      @createSky(@spectrum)
      @plotObjects() if @dimensions.uid.top(Infinity)
    
  createSky: (spectrum) =>
    id = "#{@el.attr('id')}-leaflet"
    @el.append """<div id="#{id}" style="margin: 20px; width: 100%; height: 100%; text-align: left; position: relative;"></div>"""
    @el.css { overflow: 'hidden' }
    @map = L.map(id, Map.mapOptions).setView([0, 180], 4)
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
      .bindPopup('etc')
      .openPopup()

    @circles.push circle

  plotObjects: =>
    data = @dimensions.uid.top(@limit)
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @plotObject subject for subject in data

    latlng = new L.LatLng(data[0].dec, data[0].ra)
    @map.panTo latlng
 
  selected: (itemId) =>
    item = _.find @data, (subject) ->
      subject.zooniverse_id = itemId
    latlng = new L.LatLng(item.dec, item.ra)
    circle = (c for c in @circles when c.zooniverse_id is itemId)[0]
    @selectSubject circle

  # Events
  selectSubject: (circle) =>
    # Set previous selected subject back to default icon
    if @selected_subject?
      @selected_subject.setIcon @default_icon

    @selected_subject = circle
    circle.openPopup()
    circle.setIcon @selected_icon
  
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Map
else
  window.Ubret['Map'] = Map