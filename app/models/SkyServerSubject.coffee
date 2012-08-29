
class SkyServerSubject extends Spine.Model
  @configure 'SkyServerSubject', 'ra', 'dec', 'zooniverse_id'
  
  @fetch: (count = 1) ->
    params =
      dataType: 'jsonp',
      url: "http://skyserver.herokuapp.com/skyserver/random.json"
      data:
        count: count
      callback: 'givemegalaxies'
      success: @fromJSON
    
    $.ajax(params)

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      item = @create
        ra: result.ra
        dec: result.dec
        zooniverse_id: result.objID
      @lastFetch.push item
        
  
module.exports = SkyServerSubject