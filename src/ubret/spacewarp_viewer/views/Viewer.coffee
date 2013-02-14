# 
# Layer   = window.Ubret.Spacewarp.LayerModel
# Layers  = window.Ubret.Spacewarp.LayersCollection
# 
# 
# class SpacewarpViewer extends Ubret.BaseTool
#   name: 'SpacewarpViewer'
#   source: 'http://www.spacewarps.org.s3.amazonaws.com/beta/subjects/raw/'
#   bands: ['u', 'g', 'r', 'i', 'z']
#   
#   
#   constructor: (selector) ->
#     super selector
#     
#     @on 'webfits:ready', @requestData
#   
#   start: ->
#     super
#     @getApi()
#     
#     # Initialize a collections for storing FITS images
#     console.log Layer, Layers
#     @collection = new Layers()
#   
#   getApi: ->
#     unless DataView?
#       alert 'Sorry, your browser does not support features needed for this tool.'
#       return
#     
#     # Determine if WebGL is supported
#     canvas  = document.createElement('canvas')
#     context = canvas.getContext('webgl')
#     context = canvas.getContext('experimental-webgl') unless context?
#     
#     # Load appropriate webfits library
#     lib = if context? then 'gl' else 'canvas'
#     url = "#{Ubret.BaseUrl}vendor/webfits-#{lib}.js"
#     $.getScript(url, =>
#       @trigger 'webfits:ready'
#     )
#   
#   requestData: =>
#     
#     # Clear the collection of previously requested data
#     @collection.reset()
#     
#     # Only one subject should be returned
#     prefix = @opts.data[0].metadata.id
#     
#     # Create deferred objects for each band
#     dfs = []
#     for band in @bands
#       dfs.push(new $.Deferred())
#     
#     # Define the callback for when all files are received
#     $.when.apply(this, dfs)
#       .done( (e) =>
#         console.log 'all files received'
#       )
#     
#     # Generate urls and fetch FITS
#     for band, index in @bands
#       do (band, index) =>
#         path = "#{@source}#{prefix}_#{band}.fits.fz"
#         fits = new astro.FITS.File(path, ->
#           
#           # Initialize a model and push to collection
#           layer = new Layer({band: band, fits: fits, scale: scale})
#           @collection.add(layer)
#           
#           dfs[index].resolve()
#         )
# 
# 
# window.Ubret.Spacewarp.Viewer = SpacewarpViewer