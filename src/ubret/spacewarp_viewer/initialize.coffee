
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
    
  getColorScales: ->
    colors = @getColorLayers()
    return colors.map( (d) -> d.get('nscale'))


# Model representing a single FITS image.  Used to store computed and state parameters
class Layer extends Backbone.Model

  getData: ->
    return @get('fits').getDataUnit().getFrame()


class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  dimension: 440
  bands:  ['u', 'g', 'r', 'i', 'z']
  source: 'http://spacewarps.org.s3.amazonaws.com/subjects/raw/'
  
  # Look up table for filter to wavelength conversion (CFHTLS specific)
  # CFHT MegaCam (from http://www.cfht.hawaii.edu/Instruments/Imaging/Megacam/specsinformation.html)
  wavelengths:
    'u.MP9301': 3740
    'g.MP9401': 4870
    'r.MP9601': 6250
    'i.MP9701': 7700
    'i.MP9702': 7700
    'z.MP9801': 9000
  
  # Default parameters
  defaultAlpha: 0.09
  defaultQ: 1
  defaultScales: [0.4, 0.6, 1.7]
  
  events:
    'next' : 'nextPage getNextSubject'
    'prev' : 'prevPage getNextSubject'
    'setting:alpha' : 'updateAlpha'
    'setting:q' : 'updateQ'
    'setting:scale' : 'updateScale'
    'setting:extent' : 'updateExtent'
  
  constructor: (selector) ->
    _.extend @, Ubret.Sequential
    
    super selector
    
    # Set parameters
    @stretch = 'linear'
    @collection = new Layers()
    
    # Set various deferred objects to handle asynchronous requests.
    @dfs =
      webfits: new $.Deferred()
      u: new $.Deferred()
      g: new $.Deferred()
      r: new $.Deferred()
      i: new $.Deferred()
      z: new $.Deferred()
    
    @getApi()
    @on 'data', @requestChannels
  
  # Request the appropriate WebFITS API (WebGL or Canvas)
  getApi: =>
    unless DataView?
      alert 'Sorry, your browser does not support features needed for this tool.'
    
    # Determine if WebGL is supported, otherwise fall back to canvas
    canvas  = document.createElement('canvas')
    context = canvas.getContext('webgl')
    context = canvas.getContext('experimental-webgl') unless context?

    # Load appropriate WebFITS library asynchronously
    lib = if context? then 'gl' else 'canvas'
    url = "javascripts/webfits-#{lib}.js"
    $.getScript(url, =>
      @dfs.webfits.resolve()
    )
  
  getNextSubject: =>
    @requestChannels()
  
  # Request FITS files for each channel
  requestChannels: ->
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
    
    # Load offsets if they exists
    @wfits.xOffset = @opts.xOffset or @wfits.xOffset
    @wfits.yOffset = @opts.yOffset or @wfits.yOffset
  
  # Call when all FITS received and WebFITS library is received
  allChannelsReceived: (e) =>
    console.log 'allChannelsReceived'
    @dfs = undefined
    
    scales = @collection.getColorScales()
    
    @wfits.setCalibrations(1, 1, 1)
    @wfits.setScales.apply(@wfits, @defaultScales)
    @wfits.setAlpha(@opts.alpha or @defaultAlpha)
    @wfits.setQ(@opts.q or @defaultQ)
    
    # Enable mouse controls
    @wfits.setupControls({
      onmousemove: (e) =>
        @settings({
          xOffset: @wfits.getXOffset()
          yOffset: @wfits.getYOffset()
        })
    })
    
    # Default to color composite
    @wfits.drawColor('i', 'r', 'g')
  
  setBand: =>
    band = @opts.band
    if band is 'gri'
      @wfits.drawColor('i', 'r', 'g')
    else
      # Compute the min/max of the image set
      unless @collection.hasExtent
        mins = @collection.map( (l) -> return l.get('minimum'))
        maxs = @collection.map( (l) -> return l.get('maximum'))
        @min = Math.min.apply(Math, mins)
        @max = Math.max.apply(Math, maxs)
        @wfits.setExtent(@min, @max)
        @collection.hasExtent = true
      
      @wfits?.setImage(band)
      @wfits?.setStretch(@stretch)
  
  updateAlpha: =>
    @wfits?.setAlpha(@opts.alpha)
    
  updateQ: =>
    @wfits?.setQ(@opts.q)
    
  updateScale: =>
    band = @opts.scale.band
    value = @opts.scale.value

    scales = @collection.getColorScales()
    index = if band is 'i' then 0 else if band is 'g' then 1 else 2
    scales[index] = value
    @wfits?.setScales.apply(@wfits, scales)
  
  updateStretch: =>
    @stretch = @opts.stretch
    @wfits?.setStretch(@stretch)

  getExtent: (value) ->
    return (@max - @min) * value / 1000

  updateExtent: =>
    min = @opts.extent.min
    max = @opts.extent.max
    @wfits?.setExtent(min, max)


window.Ubret.SpacewarpViewer = SpacewarpViewer
