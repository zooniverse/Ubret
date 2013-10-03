class U.DataSource 
  constructor: (@state, @url, @omittedKeys=[]) ->
    @state.when(["id"], [], @getData, @)
    @get(@state.get('id')[0]) if @state.get('id')[0]?
    if @state.get('id')[0]
      @getData({id: @state.get('id')[0]})

  update: (response) =>
    @state.set('params', response.params)
    @state.set('name', response.name)
    @state.set('id', response.id)

  get: (id) ->
    fetcher = $.ajax({
      type: "GET",
      url: _.result(@, 'url') + id,
      crossDomain: true
    })
    fetcher.then(@update)

  post: ->
    data = @state.get('params')[0]
    poster = $.ajax({
      type: 'POST',
      url: _.result(@, 'url'),
      crossDomain: true,
      data: JSON.stringify({params: data})
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

  getData: ({id}) ->
    fetcher = $.ajax({
      type: 'GET',
      url: _.result(@, 'url') + id + "/data",
      contentType: 'application/json'
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

