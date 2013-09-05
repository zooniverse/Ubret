Paginated = 
  totalPages: ({data}) ->
    @state.set('pages', Math.ceil(data.toArray().length / _.result(@, 'perPage')))

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

  currentPageData: (data, sortColumn, sortOrder, currentPage) ->
    currentPage = @setSetting('currentPage', currentPage)
    data.sort(sortColumn, sortOrder)
      .paginate(_.result(@, 'perPage'))
      .toArray()[currentPage]

module.exports = Paginated
