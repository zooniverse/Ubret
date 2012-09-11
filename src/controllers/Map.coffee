BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Map extends BaseController
  @mapOptions =
    attributionControl: false
    
  # Set the default image path for Leaflet
  L.Icon.Default.imagePath = 'css/images'

  name: "Map"
  
  constructor: ->
    super
    @circles = []
    @subscribe @subChannel, @process

  render: =>
    @html require('../views/map')({index: @index})

  start: =>
    @createSky() unless @map
    @plotObjects() if @data
    
  createSky: =>
    @map = L.map("sky-#{@index}", Map.mapOptions).setView([0, 180], 6)
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
  
  plotObject: (subject, options) =>
    coords = [subject.dec, subject.ra]
    circle = new L.marker(coords, options)
    circle.zooniverse_id = subject.zooniverse_id
    
    circle.addTo(@map)
    circle.bindPopup require('../views/map_popup')({subject})
    circle.on 'click', =>
      circle.openPopup()
      @publish [ {message: "selected", item_id: circle.zooniverse_id} ]
    @circles.push circle
    
  plotObjects: =>
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @filterData()
    @plotObject subject for subject in @filteredData

    latlng = new L.LatLng(@data[0].dec, @data[0].ra)
    @map.panTo latlng
 
  selected: (itemId) =>
    item = _.find @data, (subject) ->
      subject.zooniverse_id = itemId
    latlng = new L.LatLng(item.dec, item.ra)
    circle = (c for c in @circles when c.zooniverse_id is itemId)[0]
    circle.openPopup()
  
module.exports = Map