class Table extends Ubret.BaseTool
  name: 'Table'
  
  constructor: (options) ->
    super 
    @pages = new Array

  defaults: 
    sortOrder: 'top'
    currentPage: 0

  events:
    'next' : 'nextPage'
    'prev' : 'prevPage'
    'selector' : 'createTable'
    'keys setting:sortOrder keys-selection' : 'createHeader'
    'data selection keys-selection ' : 'createRows'
    'setting:sortOrder setting:currentPage' : 'createRows'

  # Drawing
  createTable: =>
    table = @opts.selector.append('table')
    @thead = table.append('thead')
    @tbody = table.append('tbody')

  createHeader: =>
    unless @thead? and @opts.keys? then return
    @thead.selectAll('th').remove()

    @thead.selectAll("th")
      .data(@opts.keys)
      .enter().append("th")
        .on('click', (d, i) => @sortRow d)
        .attr('data-key', (d) -> d)
        .text( (d) => 
          @unitsFormatter(@formatKey d) + ' ' +
            if d is @sortKey() then @arrow() else '')

  createRows: => 
    unless @tbody? and (not _.isEmpty(@opts.data)) then return
    @paginate()

    @tbody.selectAll('tr').remove()
    tr = @tbody.selectAll('tr')
      .data(@pages[@opts.currentPage])
      .enter().append('tr')
        .attr('data-id', (d) -> d.uid)
        .attr('class', (d) => if d.uid in @opts.selectedIds then 'selected' else '')
        .on('click', @selection)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text((d) -> return d)

    @createPages()

  createPages: =>
    @p.remove() if @p
    @p = @opts.selector
      .append('p')
      .attr('class', 'pages')
      .text("Page: #{parseInt(@opts.currentPage) + 1} of #{@numPages}")

  # Helpers

  sortKey: =>
    @opts.selectedKeys[0] or 'uid'

  paginate: =>
    # Assumes thead height of 50px and tbody height of 30px
    @numRows = Math.floor((@opts.height - 130 )/ 27) 
    @numPages = Math.ceil(@opts.data.length / @numRows)

    sortedData = _.sortBy @opts.data, (d) => d[@sortKey()]
    sortedData.reverse() if @opts.sortOrder is 'bottom'
    @pages[number] = sortedData.slice((number * @numRows), 
      ((number + 1) * @numRows)) for number in [0..(@numPages - 1)]

  currentPage: (page) =>
    if page < 0
      @opts.currentPage = @numPages - 1
    else if page >= @numPages
      @opts.currentPage = page % @numPages
    else
      @opts.currentPage = page

  toArray: (data) =>
    ret = new Array
    for key in @opts.keys
      ret.push data[key]
    return ret

  sortRow: (key) ->
    if key is @sortKey()
      if @opts.sortOrder is 'top'
        @settings {sortOrder: 'bottom'}
      else 
        @settings {sortOrder: 'top'}
    else
      @settings {sortOrder: 'top'}
      @selectKeys [key]

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

  arrow: =>
    if @opts.sortOrder is 'top'
      return '▲'
    else
      return '▼'

  nextPage: =>
    @settings
      currentPage: parseInt(@opts.currentPage) + 1

  prevPage: =>
    @settings
      currentPage: parseInt(@opts.currentPage) - 1

window.Ubret.Table = Table