Spine = require 'spine'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'

class InteractiveSubject extends Spine.Model
  @configure 'InteractiveSubject', 'redshift', 'color', 'subject', 'classification', 'type'

  @fetch: (random, limit=0, user=false) =>
    url = @url(random, limit, user)
    fetcher = Api.get url, @fromJSON

  @url: (random, limit, user) =>
    if random
      url = '/projects/galaxy_zoo/user-groups/random-classifications'
    else if user
      url = "/projects/galaxy_zoo/user-groups/#{User.current.group}/classifications/users/#{User.current.id}/classifications"
    else
      url = '/projects/galaxy_zoo/user-groups/#{User.current.group}/classifications'

    if limit isnt 0
      url = url + "?limit=#{limit}"

    return url

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      item = @create
        redshift: @result.metadata.redshift
        color: @result.metadata.color
        subject: @result.subject
        classification: @result.classification
        type: @findType(@result.subject)
      @lastFetch.push item

  @findType: (subject) =>
    if subject.smooth > subject.feature and subject.smooth > subject.artifact
      return 'smooth'
    else if subject.feature > subject.smooth and subject.feature > subject.artifact
      return 'feature'
    else
      return 'artifact'

module.exports = InteractiveSubject
