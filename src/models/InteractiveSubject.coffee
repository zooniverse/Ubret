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
      url = url + "?limit=#{limit}"

    return url

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      if result.recent.subject.metadata.survey is 'sloan'
        item = @create
          counters: result.recent.subjects[0].metadata.counters
          classification: result.recents[0].user.classification
          image: result.recent.subjects[0].location.standard
          zooniverse_id: result.recent.subjects[0].zooniverse_id
          redshift: result.recent.subjects[0].metadata.redshift
          absolute_brightness: result.recent.subjects[0].metadata.mag?.abs_r
          apparent_brightness: result.recent.subjects[0].metadata.mag?.r
          color: result.recent.subjects[0].metadata.mag?.u - result.recent.subject.metadata.mag?.r
          absolute_radius: result.recent.subjects[0].metadata.absolute_size

        @lastFetch.push item

module.exports = InteractiveSubject
