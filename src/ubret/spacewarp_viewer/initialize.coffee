
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
  source: 'http://www.spacewarps.org.s3.amazonaws.com/beta/subjects/raw/'
  
  # Look up table for filter to wavelength conversion (CFHTLS specific)
  # CFHT MegaCam (from http://www.cfht.hawaii.edu/Instruments/Imaging/Megacam/specsinformation.html)
  wavelengths:
    'u.MP9301': 3740
    'g.MP9401': 4870
    'r.MP9601': 6250
    'i.MP9701': 7700
    'i.MP9702': 7700
    'z.MP9801': 9000
  
  # Default parameter values
  defaultAlpha: 0.03
  defaultQ: 1
  
  
  constructor: (selector) ->
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
    @on 'data-received', @requestChannels
  
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
      @initWebFITS()
      @dfs.webfits.resolve()
    )
  
  # Request FITS files for each channel
  requestChannels: =>
    console.log 'requestChannels'
    
    subject = @opts.data[0]
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

            # Compute scale
            scale = @computeScale(header)

            # Initialize a model and push to collection
            layer = new Layer({band: band, fits: fits, scale: scale, minimum: min, maximum: max})
            @collection.add(layer)

            # Load texture
            @wfits.loadImage(band, arr, dataunit.width, dataunit.height)
            @dfs[band].resolve()
          )
        )
  
  # Initialize a WebFITS object
  initWebFITS: =>
    el = document.querySelector(@selector)
    @wfits = new astro.WebFITS(el, @dimension)

    unless @wfits.ctx?
      alert 'Something went wrong initializing the context'
  
  # Call when all FITS received and WebFITS library is received
  allChannelsReceived: (e) =>
    console.log 'allChannelsReceived'
    @dfs = undefined
    
    @computeNormalizedScales()
    scales = @collection.getColorScales()
    
    @wfits.setAlpha(@defaultAlpha)
    @wfits.setQ(@defaultQ)
    @wfits.setScales.apply(@wfits, scales)
    @wfits.setupControls()
    @trigger 'swviewer:loaded'
  
  start: =>
    console.log 'start'
  
  log10: (x) ->
    return Math.log(x) / Math.log(10)
    
  # Automatically determine the scale for a given image
  # TODO: Generalize for telescopes other than CFHTLS
  computeScale: (header) =>
    # Get the zero point and exposure time
    zpoint = header.get('MZP_AB') or header.get('PHOT_C')
    exptime = header.get('EXPTIME')
    
    # Get the filter and wavelength
    filter = header.get('FILTER')
    wavelength = @wavelengths[filter]
    
    return Math.pow(10, zpoint + 2.5 * @log10(wavelength) - 26.0)

  # Normalize scales for color bands
  computeNormalizedScales: =>
    colors = @collection.getColorLayers()
    
    sum = colors.reduce( (memo, value) ->
      return memo + value.get('scale')
    , 0)
    avg = sum / 3
    
    _.each(colors, (d) =>
      band = d.get('band')
      
      # Compute and set normalized scale
      nscale = d.get('scale') / avg or 1
      d.set('nscale', nscale)
      
      @trigger 'fits:scale', band, nscale
    )
    
  setBand: (band) =>
    if band is 'gri'
      @wfits.drawColor('i', 'r', 'g')
    else
      # Compute the min/max of the image set
      unless @collection.hasExtent
        @collection.hasExtent = true
        mins = @collection.map( (l) -> return l.get('minimum'))
        maxs = @collection.map( (l) -> return l.get('maximum'))
        globalMin = Math.min.apply(Math, mins)
        globalMax = Math.max.apply(Math, maxs)
        @wfits.setExtent(globalMin, globalMax)
      
      @wfits.setImage(band)
      @wfits.setStretch(@stretch)
  
  updateAlpha: (value) =>
    @wfits.setAlpha(value)
    
  updateQ: (value) =>
    @wfits.setQ(value)
    
  updateScale: (band, value) =>
    scales = @collection.getColorScales()
    index = if band is 'i' then 0 else if band is 'g' then 1 else 2
    scales[index] = value
    @wfits.setScales.apply(@wfits, scales)
  
  updateStretch: (value) =>
    @stretch = value
    @wfits.setStretch(value)


window.Ubret.SpacewarpViewer = SpacewarpViewer
