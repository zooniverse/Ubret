class U.DataSource 
  constructor: (@state, @url, @omittedKeys=[]) ->
    @state.when(["id", "params.*"], [], @put, @)
    @get(@state.get('id')[0]) if @state.get('id')[0]?

  update: (response) =>
    @state.set('params', response.params)
    if response.id?
      @getData(response.id)

  get: (id) ->
    fetcher = $.ajax({
      type: "GET",
      url: _.result(@, 'url') + id,
      crossDomain: true
    })
    fetcher.then(@update)

  put: (state) ->
    id = state.id
    params = state['params.*']
    putter = $.ajax({
      type: "PUT",
      url: _.result(@, 'url') + id,
      crossDomain: true
      data: JSON.stringify({params: params})
      contentType: 'application/json'
    })
    console.log(putter)
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

  getData: (id) ->
    id = id || @state.get('id')[0]
    fetcher = $.ajax({
      type: 'GET',
      url: _.result(@, 'url') + id + "/data",
      crossDomain: true
    })
    fetcher.then(
      ((response) => 
        if _.isEmpty(response)
          throw new Error ("No Data")
        @state.set('data', new U.Data(response, @omittedKeys))),
      ((error) =>
        @state.get('dataError', error))
    )

