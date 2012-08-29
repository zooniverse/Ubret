Api = require('zooniverse/lib/api')

class GalaxyZooSubject extends Spine.Model
  @configure 'GalaxyZooSubject', "images", "magnitude", "ra", "dec",  "zooniverse_id", "petrosian_radius", "survey", "survey_id"

  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects", params

  @withParams: (url = '', params) ->
    url += '?' + $.param(params) if params
    url

  @fetch: (count = 1) ->
    fetcher = Api.get @url(limit: count), @fromJSON 

  @fromJSON: (json) =>
    for result in json
      @create
        images: result.location
        magnitdue: result.metadata.magnitude
        ra: result.coords[0]
        dec: result.coords[1]
        zooniverse_id: result.zooniverse_id
        petrosian_radius: result.metadata.petrorad_r
        survey: result.metadata.survey
        survey_id: result.metadata.sdss_id or result.metadata.hubble_id

module.exports = GalaxyZooSubject