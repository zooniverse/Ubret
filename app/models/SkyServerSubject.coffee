
class SkyServerSubject extends Spine.Model
  @configure 'SkyServerSubject', 'objID', 'specObjID', 'ra', 'dec', 'raErr', 'decErr', 'b', 'l', 'mjd', 'type', 'u', 'g', 'r', 'i', 'z', 'err_u', 'err_g', 'err_r', 'err_i', 'err_z', 'petroR90_u', 'petroR90_g', 'petroR90_r', 'petroR90_i', 'petroR90_z', 'extinction_u', 'extinction_g', 'extinction_r', 'extinction_i', 'extinction_z', 'fracDeV_u', 'fracDeV_g', 'fracDeV_r', 'fracDeV_i', 'fracDeV_z', 'zooniverse_id'
  
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
        objID: result.objID
        specObjID: result.specObjID
        ra: result.ra
        dec: result.dec
        raErr: result.raErr
        decErr: result.decErr
        b: result.b
        l: result.l
        mjd: result.mjd
        type: result.type
        u: result.u
        g: result.g
        r: result.r
        i: result.i
        z: result.z
        err_u: result.err_u
        err_g: result.err_g
        err_r: result.err_r
        err_i: result.err_i
        err_z: result.err_z
        petroR90_u: result.petroR90_u
        petroR90_g: result.petroR90_g
        petroR90_r: result.petroR90_r
        petroR90_i: result.petroR90_i
        petroR90_z: result.petroR90_z
        extinction_u: result.extinction_u
        extinction_g: result.extinction_g
        extinction_r: result.extinction_r
        extinction_i: result.extinction_i
        extinction_z: result.extinction_z
        fracDeV_u: result.fracDeV_u
        fracDeV_g: result.fracDeV_g
        fracDeV_r: result.fracDeV_r
        fracDeV_i: result.fracDeV_i
        fracDeV_z: result.fracDeV_z
        zooniverse_id: null
      @lastFetch.push item
        
  
module.exports = SkyServerSubject