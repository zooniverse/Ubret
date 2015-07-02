Spine = require 'spine'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'

class InteractiveSubject extends Spine.Model
  @configure 'InteractiveSubject', 'redshift', 'color', 'subject', 'classification', 'counters', 'image', 'zooniverse_id', 'absolute_brightness', 'apparent_brightness', 'absolute_radius'

  @fetch: ({random, limit, user}) =>
    url = @url(random, limit, user)
    fetcher = Api.getJSON url, @fromJSON

  @url: (random, limit, user) =>
    if random
      url = '/user_groups/506a216fd10d240486000002/recents'
    else if user
      url = "/user_groups/#{User.current.user_group_id}/user_recents"
    else
      url = "/user_groups/#{User.current.user_group_id}/recents"

    limit = parseInt(limit) + 5
    if limit isnt 0
      url = url + "?limit=#{limit}&project_id=galaxy_zoo"

    return url

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      if result.recent.subjects[0]?.metadata?.survey is 'sloan' or result.recent.subjects[0]?.metadata?.survey is 'sloan_singleband'
        item = @create
          counters: result.recent.subjects[0].metadata.counters
          classification: result.recent.user.classification
          image: result.recent.subjects[0].location.standard
          zooniverse_id: result.recent.subjects[0].zooniverse_id
          redshift: result.recent.subjects[0].metadata.redshift
          absolute_brightness: result.recent.subjects[0].metadata.mag?.abs_r
          apparent_brightness: result.recent.subjects[0].metadata.mag?.r
          color: result.recent.subjects[0].metadata.mag?.u - result.recent.subjects[0].metadata.mag?.r
          absolute_radius: result.recent.subjects[0].metadata.absolute_size

      else if result.recent.subjects[0]?.metadata?.survey is 'candels_2epoch'
        item = @create
          counters: result.recent.subjects[0].metadata.counters
          classification: result.recent.user.classification
          image: result.recent.subjects[0].location.standard
          zooniverse_id: result.recent.subjects[0].zooniverse_id
          redshift: result.recent.subjects[0].metadata.redshift
          absolute_brightness: result.recent.subjects[0].metadata.mag?.abs_H
          apparent_brightness: result.recent.subjects[0].metadata.mag?.H
          color: result.recent.subjects[0].metadata.mag?.H - result.recent.subjects[0].metadata.mag?.J
          absolute_radius: result.recent.subjects[0].metadata.absolute_size

      else if result.recent.subjects[0]?.metadata?.survey is 'goods_full'
        item = @create
          counters: result.recent.subjects[0].metadata.counters
          classification: result.recent.user.classification
          image: result.recent.subjects[0].location.standard
          zooniverse_id: result.recent.subjects[0].zooniverse_id
          redshift: result.recent.subjects[0].metadata.redshift
          absolute_brightness: result.recent.subjects[0].metadata.mag?.abs_Z
          apparent_brightness: result.recent.subjects[0].metadata.mag?.Z
          color: result.recent.subjects[0].metadata.mag?.I - result.recent.subjects[0].metadata.mag?.Z
          absolute_radius: result.recent.subjects[0].metadata.absolute_size

        @lastFetch.push item

module.exports = InteractiveSubject
