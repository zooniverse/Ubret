class U.Data
  constructor: (@data, @omittedKeys) ->
    @_invoked = []
    @_perPage = 0
    @_projection = ['*']
    @_sortOrder = 'a'
    @_sortProp = 'uid'
    @keys = _.chain(@data).map(((d) =>
        _.keys(_.omit(d, @omittedKeys...))))
      .flatten().uniq().value()
