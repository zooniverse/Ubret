
#
# Define collection and model used in viewer
#

# Collection of layers where each layer corresponds to a FITS image
class LayersCollection extends Backbone.Collection
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
class LayerModel extends Backbone.Model

  getData: ->
    return @get('fits').getDataUnit().getFrame()


class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  dimension: 441
  bands:  ['u', 'g', 'r', 'i', 'z']
  source: 'http://www.spacewarps.org.s3.amazonaws.com/beta/subjects/raw/'
  
  constructor: (selector) ->
    super selector
    
    # Set up some deferred objects
    @deferreds = []
    @deferreds.push new $.Deferred()  # one for api
    @deferreds.push new $.Deferred()  # one for data
    
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
    
    # Run when Api and data have been received
    $.when.apply(this, @deferreds)
      .done( (e) =>
        console.log e
      )
  
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
      @deferreds[0].resolve()
    )
  
  start: =>
    subject = @opts.data[0]
    prefix  = subject.metadata.id
    
    # Create one deferred for each band
    deferreds = []
    for band, index in @bands
      deferreds.push new $.Deferred()
      
    # Request FITS images
    for band, index in @bands
      do (band, index) =>
        path = "#{@source}#{prefix}_#{band}.fits.fz"
        new astro.FITS.File(path, (fits) =>
          console.log fits
          hdu = fits.getHDU()
        )


window.Ubret.SpacewarpViewer = SpacewarpViewer