
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
    layers.push @where({band: 'g'})[0]
    layers.push @where({band: 'r'})[0]
    layers.push @where({band: 'i'})[0]
    return layers

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
    
    # Request the appropriate webfits api (canvas or webgl)
    @getApi()
    
    # Run when the webfits api is received
    @on 'swviewer:ready', =>
      # NOTE: Dimensions and global extent are hard coded
      el = document.querySelector(@selector)
      @wfits = new astro.WebFITS.Api(el, @dimension, @dimension)
      @wfits.setGlobalExtent(@surveyMinPixel, @surveyMaxPixel)
      ctx = @wfits.getContext()
      
      unless ctx?
        alert 'Something went wrong initializing the context'
      
      @unbind 'swviewer:ready'
  
  getApi: =>
    unless DataView?
      alert 'Sorry, your browser does not support features needed for this tool.'
    
    # Determine if WebGL is supported, otherwise fall back to canvas
    canvas  = document.createElement('canvas')
    context = canvas.getContext('webgl')
    context = canvas.getContext('experimental-webgl') unless context?

    # Load appropriate webfits library asynchronously
    lib = if context? then 'gl' else 'canvas'
    url = "javascripts/webfits-#{lib}.js"
    $.getScript(url, =>
      @trigger 'swviewer:ready'
    )
  
  start: =>
    # Initialize a collections for storing FITS images
    @collection = new Layers()
    
    subject = @opts.data[0]
    prefix  = subject.metadata.id
    
    # Create one deferred for each band
    dfs = []
    for band, index in @bands
      dfs.push new $.Deferred()
    
    # Setup callback for when all requests are received
    $.when.apply(this, dfs)
      .done( (e) =>
        @computeNormalizedScales()
        
        # Set default parameters
        @trigger 'fits:alpha', @defaultAlpha
        @trigger 'fits:Q', @defaultQ
        
        @wfits.setAlpha(@defaultAlpha)
        @wfits.setQ(@defaultQ)
        @wfits.setupMouseInteraction()
        
        @trigger "fits:ready"
      )
    
    # Request FITS images
    for band, index in @bands
      do (band, index) =>
        path = "#{@source}#{prefix}_#{band}.fits.fz"
        
        new astro.FITS.File(path, (fits) =>
          hdu = fits.getHDU()
          header = hdu.header
          dataunit = hdu.data
          
          # Get image data
          arr = dataunit.getFrame()
          
          # Compute scale
          scale = @computeScale(header)
          
          # Initialize a model and push to collection
          layer = new Layer({band: band, fits: fits, scale: scale})
          @collection.add(layer)
          
          # Load texture
          @wfits.loadTexture(band, arr)
          
          dfs[index].resolve()
        )
  
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
    gri = @collection.getColorLayers()
    
    sum = gri.reduce( (memo, value) ->
      return memo + value.get('scale')
    , 0)
    avg = sum / 3
    
    _.each(gri, (d) =>
      band = d.get('band')
      
      # Compute and set normalized scale
      nscale = d.get('scale') / avg or 1
      d.set('nscale', nscale)
      
      # Send to web fits object
      @trigger 'fits:scale', band, nscale
      @wfits.setScale band, nscale
    )


window.Ubret.SpacewarpViewer = SpacewarpViewer