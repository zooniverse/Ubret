Paginated = 
  totalPages: ({pagedData}) ->
    @state.set('pages', pagedData.length) 

  currentPage: (page) ->
    return page unless @state.get('pages')
    pages = @state.get('pages')
    if page < 0
      pages - 1
    else if page >= pages
      page % pages
    else if _.isNull(page) or _.isUndefined(page)
      0
    else
      page

  pageData: ({data, sortColumn, sortOrder}) ->
    paged = data.sort(sortColumn, sortOrder)
      .paginate(_.result(@, 'perPage'))
      .toArray()
    @state.set('pagedData', paged)

module.exports = Paginated
