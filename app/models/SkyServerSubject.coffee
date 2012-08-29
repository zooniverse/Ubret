
class SkyServerSubject extends Spine.Model
  @configure 'SkyServerSubject', 'metadata'
  
  @fetch: (count = 1) ->
    params =
      dataType: 'jsonp',
      url: "http://skyserver.herokuapp.com/skyserver.json"
      data:
        number: count
        test:   'blah'
      callback: 'givemegalaxies'
      success: (data) =>
        console.log data
        
    console.log 'here'
    $.ajax(params)
  
module.exports = SkyServerSubject