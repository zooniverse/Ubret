class Data
  constructor: (data) ->A
    if typeof data is 'Array'
      @wrappedData = Lazy(data)
    else
      @wrappedData = data

  where: (func) ->
    @wrappedData = @wrappedData.filter(func)
    @

  map: (func) ->
    @wrappedData = @wrappedData.map func
    @

  field: (name, func) ->
    @wrappedData = @wrappedData.map (i) ->
      i[name] = func(i)
      i
    @

  page: (number, perPage) ->
    if typeof perPage is 'Number'
    else
    

  project: (keys...) ->
    unless keys[0] is '*'
      @wrappedData = @wrappedData.map((i) -> Lazy(i).pick.apply(@, keys).toObject())
    @wrappedData.toArray()

  
    