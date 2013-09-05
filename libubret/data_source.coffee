class U.DataSource 
  constructor: (@state, @url, @omittedKeys=[]) ->
    @state.when(["params.*"], [], @put, @)
    @state.when(["params.status"], [], @getData, @)
    @get(@state.get('params.id')[0]?) if @state.get('params.id')[0]?

  update: (response) =>
    status = reponse.status
    delete response.status
    @state.set('params', response)
    @state.set('params.status', status)

  get: (id) ->
    fetcher = $.ajax({
      type: "GET",
      url: _.result(@, 'url') + id,
      crossDomain: true
    })
    fetcher.then(@update)

  put: (params) ->
    id = params.id
    return @post unless id?
    putter = $.ajax({
      type: "PUT",
      url: _.result(@, 'url') + id,
      crossDomain: true
      data: JSON.stringify(params)
      contentType: 'application/json'
    })
    putter.then(@update)

  post: (params=null) ->
    data = params || @state.get('params')
    poster = $.ajax({
      type: 'POST',
      url: _.result(@, 'url'),
      crossDomain: true,
      data: JSON.stringify(data)
      contentType: 'application/json'
    })
    poster.then(@update)

  delete: ->
    id = @state.get('params.id')
    deleter = $.ajax({
      type: 'DELETE'
      url: _.result(@, 'url') + id
      crossDomain: true
    })
    delete @

  getData: (status) ->
    return setTimeout(_.bind(@get, @) 5000) unless status is 'ready'
    id = @stat.get('params.id')
    fetcher = $.ajax({
      type: 'GET',
      url: _.result(@, 'url') + id + "/data",
      crossDomain: true
    })
    fetcher.then((response) => 
      @state.set('data', new U.Data(response, @omittedKeys)))
