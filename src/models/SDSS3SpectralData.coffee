Spine = require('spine')

class SDSS3SpectralData extends Spine.Model
  @configure 'SDSS3SpectralData', 'ra', 'dec', 'z', 'wavelengths', 'best_fit', 'flux'
  
  @spectrumID = /(?:all|sdss|boss)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/
  
  @fetch: (sdssid) =>
    match = sdssid.match(SDSS3SpectralData.spectrumID)
    unless match?
      alert 'SDSS Spectral ID is malformed.'
      return null
    
    # dfd1 = new $.Deferred()
    # dfd2 = new $.Deferred()
    # p1 = dfd1.promise()
    # p2 = dfd2.promise()
    # p1.pipe (obj) =>
    #   console.log 'Requesting spectrum'
    #   params =
    #     url: "http://api.sdss3.org/spectrum?id=#{sdssid}&format=json"
    #     success: @fromJSON
    #     
    #   $.ajax(params)
    # p1.pipe (obj) =>
    #   console.log 'Requesting spectrum lines'
    #   params =
    #     url: "http://api.sdss3.org/spectrumLines?id=#{sdssid}&format=json"
    #   $.ajax(params)
    
    # dfd1.resolve()
    # return dfd2
    params =
      url: "http://api.sdss3.org/spectrum?id=#{sdssid}&format=json&fields=ra,dec,z,wavelengths,best_fit,flux"
      success: @fromJSON
      
    $.ajax(params)
  
  @fromJSON: (json) =>
    @lastFetch = new Array
    for key, value of json[0]
      item = @create json[0][key]
      console.log item
      @lastFetch.push item
  
module.exports = SDSS3SpectralData