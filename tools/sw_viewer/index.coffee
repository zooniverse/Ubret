#
# Define collection and model used in viewer
#

# Collection of layers where each layer corresponds to a FITS image
class Layers extends Backbone.Collection
  hasExtent: false
  
  reset: =>
    super
    @hasExtent = false
  
  getColorLayers: ->
    layers = []
    layers.push @where({band: 'i'})[0]
    layers.push @where({band: 'r'})[0]
    layers.push @where({band: 'g'})[0]
    return layers

# Model representing a single FITS image.  Used to store computed and state parameters
class Layer extends Backbone.Model

  getData: ->
    return @get('fits').getDataUnit().getFrame()

class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  dimension: 440
  bands:  ['u', 'g', 'r', 'i', 'z']
  source: 'http://spacewarps.org/subjects/raw/'


  events:
    'data'            : 'requestChannels'
    'next'            : 'nextPage getNextSubject'
    'prev'            : 'prevPage getNextSubject'
    'setting:alpha'   : 'updateAlpha'
    'setting:q'       : 'updateQ'
    'setting:scales'  : 'updateScale'
    'setting:extent'  : 'updateExtent'
    'setting:band'    : 'updateBand'
    'setting:stretch' : 'updateStretch'
  
  
  constructor: (selector) ->
    _.extend @, Ubret.Sequential
    
    super selector
    @collection = new Layers()
    @ready = false
    
    # Set various deferred objects to handle asynchronous requests.
    @dfs =
      u: new $.Deferred()
      g: new $.Deferred()
      r: new $.Deferred()
      i: new $.Deferred()
      z: new $.Deferred()
    @dfsWebfits = new $.Deferred()
    @getApi()
  
  # Request the appropriate WebFITS API (WebGL or Canvas)
  getApi: ->
    
    unless DataView?
      alert 'Sorry, your browser does not support features needed for this tool.'
      return
    
    # Determine if WebGL is supported, otherwise fall back to canvas
    canvas  = document.createElement('canvas')
    for name in ['webgl', 'experimental-webgl']
      
      try
        context = canvas.getContext(name)
        ext = context.getExtension('OES_texture_float')
      
      catch error
        continue
      
      break if context?
    
    # Check context and floating point texture extension on platform
    lib = if ext? then 'gl' else 'canvas'
    
    # Load appropriate WebFITS library asynchronously
    url = "javascripts/webfits-#{lib}.js"
    $.getScript(url, =>
      @dfsWebfits.resolve()
    )
  
  getNextSubject: =>
    @requestChannels()
  
  # Request FITS files for each channel
  requestChannels: ->
    @ready = false
    
    @dfsWebfits.then =>
      @initWebFITS()
      
      # Set various deferred objects to handle asynchronous requests.
      @dfs =
        u: new $.Deferred()
        g: new $.Deferred()
        r: new $.Deferred()
        i: new $.Deferred()
        z: new $.Deferred()
      
      subject = @currentPageData()[0]
      prefix  = subject.metadata.id
      
      # Set callback for when all channels and WebFITS Api received
      $.when.apply(null, _.values(@dfs))
        .done(@allChannelsReceived)
      
      for band, index in @bands
        do (band, index) =>
          path = "#{@source}#{prefix}_#{band}.fits.fz"
          
          new astro.FITS.File(path, (fits) =>
            hdu = fits.getHDU()
            header = hdu.header
            dataunit = hdu.data
            
            # Get image data
            dataunit.getFrameAsync(0, (arr) =>
              
              # Compute extent
              [min, max] = dataunit.getExtent(arr)
              
              # Initialize a model and push to collection
              layer = new Layer({band: band, fits: fits, minimum: min, maximum: max})
              @collection.add(layer)
              
              # Load texture
              @wfits.loadImage(band, arr, dataunit.width, dataunit.height)
              @dfs[band].resolve()
            )
          )
    
  # Initialize a WebFITS object
  initWebFITS: =>
    @wfits?.teardown()
    @wfits = new astro.WebFITS(@el, @dimension)
    unless @wfits.ctx?
      alert 'Something went wrong initializing the context'
      return
    
    # Load offsets if they exists
    @wfits.xOffset = @opts.xOffset or @wfits.xOffset
    @wfits.yOffset = @opts.yOffset or @wfits.yOffset
    @wfits.zoom = @opts.zoom or @wfits.zoom
  
  # Call when all FITS received and WebFITS library is received
  allChannelsReceived: (e) =>
    @dfs = undefined
    @ready = true
    
    # Get extent for each layer and add to settings
    mins = @collection.map( (d) -> return d.get('minimum') )
    maxs = @collection.map( (d) -> return d.get('maximum') )
    gMin = Math.min.apply(Math, mins)
    gMax = Math.min.apply(Math, maxs)
    
    @opts.gMin = gMin
    @opts.gMax = gMax
    
    @wfits.setCalibrations(1, 1, 1)
    
    # Get settings or fallback to defaults
    min = @opts.extent?.min or gMin
    max = @opts.extent?.max or gMax
    
    @wfits.setScales.apply(@wfits, @opts.scales)
    @wfits.setAlpha(@opts.alpha)
    @wfits.setQ(@opts.q)
    @wfits.setExtent(min, max)
    
    # Enable mouse controls
    @wfits.setupControls({
      onmousemove: (e) =>
        @settings({
          xOffset: @wfits.getXOffset()
          yOffset: @wfits.getYOffset()
        })
      onzoom: (e) =>
        @settings({
          zoom: @wfits.zoom
        })
    })
    
    @updateBand()
    @trigger 'swviewer:loaded'
  
  updateBand: =>
    if @ready
      band = @opts.band
      if @wfits?
        if band is 'gri'
          @wfits.drawColor('i', 'r', 'g')
        else
          @wfits.setImage(band)
          @wfits.setStretch(@opts.stretch)
  
  updateAlpha: =>
    @wfits?.setAlpha(@opts.alpha) if @ready
    
  updateQ: =>
    @wfits?.setQ(@opts.q) if @ready
    
  updateScale: =>
    @wfits?.setScales.apply(@wfits, @opts.scales) if @ready
  
  updateStretch: =>
    @wfits?.setStretch(@opts.stretch) if @ready

  updateExtent: =>
    @wfits?.setExtent(@opts.extent.min, @opts.extent.max) if @ready


window.Ubret.SpacewarpViewer = SpacewarpViewer
