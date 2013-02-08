
class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  source: 'http://www.spacewarps.org.s3.amazonaws.com/beta/subjects/raw/'
  bands: ['u', 'g', 'r', 'i', 'z']
  
  
  constructor: (selector) ->
    super selector

  start: =>
    super
    
    FITS = @astro.FITS
    
    # Fetch FITS files
    
    # Only one subject should be returned
    prefix = @opts.data[0].metadata.id
    
    # Generate urls
    for band in @bands
      url = "#{@source}#{prefix}_#{band}.fits.fz"
      console.log url
      fits = new FITS.File(url, ->
        console.log @
      )
    
    
window.Ubret.SpacewarpViewer = SpacewarpViewer