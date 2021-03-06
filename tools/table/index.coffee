class Table extends U.Tool
  name: 'Table'
  className: 'table'

  mixins: [require('tools/mixins/paginated')]
  
  domEvents: {
    'click button' : 'changePage'
  }
  
  constructor: ->
    super 

  initEl: ->
    if _.isNull(@d3el.select('table')[0][0])
      @table = @d3el.append('table')
      @thead = @table.append('thead')
      @tbody = @table.append('tbody')
      @d3el.append('div').attr('class', 'legend')
      @d3el.append('div').attr('class', 'page-controls')

  events: [ 
    {
      req: ['pagedData']
      opt: []
      fn: 'totalPages'
    },
    {
      req: ['data', 'sortOrder', 'sortColumn', 'height']
      opt: []
      fn: 'pageData'
    },
    {
      req: ['pagedData', 'currentPage', 'pages']
      opt: ['selection']
      fn: 'drawBody'
    },
    {
      req: ['data', 'sortOrder', 'sortColumn']
      opt: []
      fn: 'drawHeader'
    },
    {
      req: ['pages', 'currentPage']
      opt: []
      fn: 'drawPages'
    },
    {
      req: ['pages', 'currentPage']
      opt: []
      fn: 'drawButtons'
    }
  ]

  # Drawing
  drawHeader: ({data, sortOrder, sortColumn}) ->
    @initEl()

    th = @thead.selectAll("th")
      .data(data.keys(), (d) -> "#{d}-#{sortColumn is d}")

    th.enter().append("th")
      .on('click', @sortRow)

    th.text(@headerText)

    th.exit().remove()

  drawBody: ({pagedData, currentPage, selection}) ->
    currentPage = @currentPage(currentPage)
    @initEl()

    data = pagedData[currentPage] 

    tr = @tbody.selectAll('tr')
      .data(data, (d, i) -> "#{i}-#{d.uid}")

    tr.enter().append('tr')

    tr.attr('data-id', (d) -> d.uid)
      .attr('class', (d) -> if d.uid in (selection || []) then 'selected' else '')
      .on('click', @selection)

    tr.exit().remove()
  
    td = tr.selectAll('td')
      .data(((d) => _.chain(d).omit(@nonDisplayKeys...).pairs(d).value()), 
            ((d) -> "#{d[0]}-#{d[1]}"))

    td.enter().append('td')
      .text(([key, val]) -> 
        if typeof val isnt 'string'
          d3.format(',.02f')(val)
        else
          val)

    td.exit().remove()

  drawPages: ({pages, currentPage}) ->
    @initEl() 

    @$el.find('.legend').html(@pageTemplate(pages, currentPage))

  # Pagination
  perPage: -> 
    # Assumes top margin + bottom margins = 130px,
    # and table cells are 27px high.
    Math.floor((@state.get('height') - 90 )/ 27) 

  # UI Events
  sortRow: (key) =>
    if key is @state.get('sortColumn')[0]
      if @state.get('sortOrder')[0] is 'a'
        @setSetting('sortOrder', 'd')
      else 
        @setSetting('sortOrder', 'a')
    else
      @setSetting('sortOrder', 'a') 
      @setSetting('sortColumn', key)

  selection: (d, i) =>
    ids = @state.get('selection')[0]
    unless ids
      ids = [d.uid]
    else if d3.event.shiftKey
      unless d.uid in ids
        ids.push d.uid
      else
        ids = _.without(ids, d.uid )
    else if d.uid in ids
      ids = _.without(ids, d.uid)
    else 
      ids = [d.uid]
    @state.set('selection', ids)

  # Templating
  pageTemplate: (pages, current) ->
    """
    <p>
      <span class="current">#{current + 1}</span>
       of 
      <span class="pages">#{pages}</span>
    </p>
    """

  headerText: (key) =>
    if key is @state.get('sortColumn')[0]
      key + @arrow()
    else
      key

  arrow: =>
    if @state.get('sortOrder')[0] is 'a'
      return '▲'
    else
      return '▼'

module.exports = Table