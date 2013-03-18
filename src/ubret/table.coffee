class Table extends Ubret.BaseTool
  name: 'Table'
  
  constructor: ->
    _.extend @, Ubret.Paginated
    super 

  events:
    'next' : 'nextPage'
    'prev' : 'prevPage'
    'setting:sortColumn setting:sortOrder': 'sort'
    'selection next prev height' : 'drawRows'
    'next prev height' : 'drawPages'

  selector: ->
    super
    @table = @d3el.append('table')
    @

  keys: ->
    super
    @drawHeader()
    @

  data: ->
    super
    @drawRows()
    @drawPages()
    @

  sort: ->
    return if _.isEmpty(@opts.data) or not @table
    @drawHeader()
    @drawRows()

  # Drawing
  drawHeader: ->
    @thead = @table.insert('thead', ":first-child") unless @thead
    @thead.selectAll('th').remove()

    @thead.selectAll("th")
      .data(@opts.keys)
      .enter().append("th")
        .on('click', (d, i) => @sortRow d)
        .attr('data-key', (d) -> d)
        .text( (d) => 
          @unitsFormatter(@formatKey d) + ' ' +
            if d is @opts.sortColumn then @arrow() else '')

  drawRows: -> 
    @tbody = @table.append('tbody') unless @tbody
    @tbody.selectAll('tr').remove()

    tr = @tbody.selectAll('tr')
      .data(@page(@opts.currentPage))
      .enter().append('tr')
        .attr('data-id', (d) -> d.uid)
        .attr('class', (d) => 
          if d.uid in @opts.selectedIds then 'selected' else '')
        .on('click', @selection)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text((d) -> return d)

  drawPages: ->
    @p.remove() if @p
    @p = @d3el
      .append('p')
      .attr('class', 'pages')
      .text("Page: #{parseInt(@opts.currentPage) + 1} of #{@pages()}")

  # Pagination
  perPage: -> 
    # Assumes top margin + bottom margins = 130px,
    # and table cells are 27px high.
    Math.floor((@opts.height - 130 )/ 27) 

  pageSort: (data) ->
    sorted = _.sortBy(data, (d) => d[@opts.sortColumn])
    sorted.reverse() if @opts.sortOrder is 'bottom'
    sorted

  # UI Events
  sortRow: (key) ->
    if key is @opts.sortColumn
      if @opts.sortOrder is 'top'
        @settings {sortOrder: 'bottom'}
      else 
        @settings {sortOrder: 'top'}
    else
      @settings 
        sortOrder: 'top'
        sortColumn: key

  selection: (d, i) =>
    ids = @opts.selectedIds
    if d3.event.shiftKey
      if not (d.uid in ids)
        ids.push d.uid
      else
        ids = _.without ids, d.uid 
    else
      ids = [d.uid]
    @selectIds ids

  # Helpers
  toArray: (data) =>
    ret = new Array
    for key in @opts.keys
      ret.push data[key]
    return ret

  arrow: =>
    if @opts.sortOrder is 'top'
      return '▲'
    else
      return '▼'

window.Ubret.Table = Table