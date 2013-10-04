class U.Data
  constructor: (@data, @omittedKeys) ->
    @_invoked = []
    @_perPage = 0
    @_projection = ['*']
    @_sortOrder = 'a'
    @_sortProp = 'uid'
    @_keys = _.without(_.keys(@data[0]), @omittedKeys...)

  clone: ->
    data = new U.Data(@data, @omittedKeys)
    data._invoked = _.map(@_invoked, _.clone)
    data._perPage = @_perPage
    data._projection = _.clone(@_projection)
    data._sortOrder = @_sortOrder
    data._sortProp = @_sortProp
    data._keys = _.clone(@_keys)
    return data

  keys: ->
    @_keys

  filter: (fn) ->
    @clone()._invoke({fn: fn})

  removeFilter: (fn) ->
    @clone()._revoke({fn: fn})

  addField: (field)->
    data = @clone()._invoke(field)
    data._keys = data._keys.concat(field.name)
    data

  removeField: (field) ->
    unless field.fn?
      field = _.find(@invoke, (a) -> a.key is field.name)
    data = @clone()._revoke(field)
    data._keys = _.without(data._keys, name)
    data

  project: (fields...) ->
    data = @clone()
    data._projection = fields
    data

  sort: (prop, order='a') ->
    data = @clone()
    data._sortProp = prop
    data._sortOrder = order
    data

  paginate: (perPage) ->
    data = @clone()
    data._perPage = perPage
    data

  toArray: (take) ->
    U.pipeline.call(@,
      @_applyInvoked,
      @_applySort,
      @_applyPaginate,
      @_take
      @_applyProjection)(@data, take)

  select: (fn) ->
    _.pluck(_.filter(@data, fn), 'uid')

  first: (take=1) ->
    @toArray(take)

  each: (fn, take) ->
    _.each(@toArray(take), fn, @)

  # Data.query accepts a 'query obejct with the following fields:
  #   select: Array of atributes to include. Blank or ["*"] for all fields
  #   where: Array of filter functions
  #   withFields: Array of field options where
  #     name: field name
  #     fn: function that creates field
  #   sort: Object where
  #     prop: property to sort on. Default: 'uid'
  #     order: 'a' for ascending. 'd' for descending. Default: 'a'
  #   perPage: Number of items per page. Default: 0

  query: (q) ->
    _.defaults(q, {
      perPage: 0
      sort: {prop: 'uid', order: 'a'}
      withFields: []
      where: []
      select: ['*']
    })

    data = @clone()
    data._invoked = data._invoked.concat(
      _.map(q.where, (fn) -> {fn: fn}).concat(q.withFields)
    )
    data._sortProp = q.sort.prop
    data._sortOrder = q.sort.order
    data._perPage = q.perPage
    data._projection = q.select
    data

  # Private

  _applyInvoked: (data) ->
    _.reduce(@_invoked, ((data, {name, fn}) =>
      if name?
        return @_applyField(data, name, fn)
      else
        return @_applyFilter(data, fn) 
    ), data)

  _applyField: (data, name, fn) ->
    _.map(data, ((d) ->
      d[name] = fn(d, data)
      return d
    ))

  _applyFilter: (data, fn) ->
    _.filter(data, fn)
  
  _applySort: (data) ->
    sorted = _.sortBy(data, (d) => d[@_sortProp])
    if @_sortOrder is 'd'
      return sorted.reverse()
    return sorted

  _applyPaginate: (data, take=null) ->
    return data if @_perPage is 0
    return [data] if @_perPage is 1
    _.reduce(data, ((m, d, i) =>
      return m if m.length is take
      if (i % @_perPage) is 0
        m.push([d])
      else
        m[m.length - 1].push(d)
      return m
    ), [])

  _take: (data, take) ->
    return data if (@_perPage > 0)
    data.slice(0, take)

  _applyProjection: (data) ->
    apply = (projection, data) ->
      _.map(data, (d) -> _.pick(d, projection...))

    if @_projection[0] is "*"
      data
    else if @_perPage > 0
      _.map(data, _.partial(apply, @_projection))
    else
      apply(@_projection, data)

  _invoke: (action) ->
    @_invoked = @_invoked.concat(action)
    @

  _revoke: (action) ->
    @_invoked = _.without(@_invoked, action)
    @

U.query = (data, query, take=null) ->
  data.query(query).toArray(take)
