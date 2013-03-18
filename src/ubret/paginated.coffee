Ubret.Paginated = 
  page: (number) ->
    startIndex = number * _.result(@, 'perPage')
    endIndex = (number + 1) * _.result(@, 'perPage')
    sortedData = @pageSort(@opts.data)
    sortedData.slice(startIndex, endIndex)

  pages: ->
    Math.ceil(@opts.data.length / _.result(@, 'perPage'))

  currentPage: (page) ->
    if _.isEmpty(@opts.data)
      @opts.currentPage = page
    else if page < 0
      @opts.currentPage = @pages() - 1
    else if page >= @pages()
      @opts.currentPage = page % @pages()
    else
      @opts.currentPage = page

  nextPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) + 1

  prevPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) - 1

