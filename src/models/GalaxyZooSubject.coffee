Api = require('zooniverse/lib/api')
Spine = require('spine')

class GalaxyZooSubject extends Spine.Model
  @configure 'GalaxyZooSubject', "image", "magnitude", "ra", "dec",  "zooniverse_id", "petrosian_radius", "survey", "survey_id"

  constructor: ->
    super

  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects", params

  @withParams: (url = '', params) ->
    url += '?' + $.param(params) if params
    url

  @fetch: (count = 1) ->
    fetcher = Api.get @url(limit: count), @fromJSON 

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      item = @create
        image: result.location.standard
        magnitdue: result.metadata.magnitude
        ra: result.coords[0]
        dec: result.coords[1]
        zooniverse_id: result.zooniverse_id
        petrosian_radius: result.metadata.petrorad_r
        survey: result.metadata.survey
        survey_id: result.metadata.sdss_id or result.metadata.hubble_id
      @lastFetch.push item

  @newImage: (location) ->
    image = new Image
    image.src = location
    return image

module.exports = GalaxyZooSubject