
class SkyServerSubject extends Spine.Model
  @configure 'SkyServerSubject', 'metadata'
  
  @fetch: (count = 1) ->
    params =
      dataType: 'jsonp',
      url: "http://skyserver.herokuapp.com/skyserver/random.json"
      data:
        count: count
      callback: 'givemegalaxies'
      success: (data) =>
        console.log object['objID'], object['ra'], object['dec'] for object in data
    
    $.ajax(params)
  
module.exports = SkyServerSubject