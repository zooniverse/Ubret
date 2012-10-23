Spine = require('spine')

class SDSS3SpectralData extends Spine.Model
  @configure 'SDSS3SpectralData', 'ra', 'dec', 'z', 'wavelengths', 'best_fit', 'flux', 'spectralLines'
  
  @spectrumID = /(?:all|sdss|boss)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/
  
  @fetch: (sdssid) =>
    match = sdssid.match(SDSS3SpectralData.spectrumID)
    unless match?
      alert 'SDSS Spectral ID is malformed.'
      return null
    
    spectrumUrl = "http://api.sdss3.org/spectrum?id=#{sdssid}&format=json&fields=ra,dec,z,wavelengths,best_fit,flux"
    specLineUrl = "http://api.sdss3.org/spectrumLines?id=#{sdssid}"
    
    return $.when($.ajax(spectrumUrl), $.ajax(specLineUrl)).done (spectrum, lines) =>
      SDSS3SpectralData.fromJSON(spectrum[0], lines)

  @fromJSON: (spectrum, lines) =>
    @lastFetch = new Array
    for key, value of spectrum[0]
      spectralLines = {}
      for line in lines[0][key]
        spectralLines[line.name] = line.wavelength
      spectrum[0][key]['spectralLines'] = spectralLines
      item = @create spectrum[0][key]
      @lastFetch.push item
    
module.exports = SDSS3SpectralData