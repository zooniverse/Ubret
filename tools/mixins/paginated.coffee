Paginated = 
  buttonTemplate: require('./templates/page')

  totalPages: ({pagedData}) ->
    @state.set('pages', pagedData.length) 

  currentPage: (page) ->
    [pages] = @state.get('pages')
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

  drawButtons: ({currentPage}) ->
    @$el.find('.page-controls').html(@buttonTemplate({currentPage: currentPage}))
    @$el.find('.page-controls').on('click', 'button', _.bind(@changePage, @))

  changePage: (ev) ->
    @state.set('currentPage', @currentPage(parseInt(ev.target.dataset.page)))

module.exports = Paginated
