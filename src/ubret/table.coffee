class Table extends Ubret.BaseTool
  name: 'Table'
  
  constructor: (selector) ->
    super selector
    @opts.sortOrder = 'top'
    @opts.currentPage = 0
    @pages = new Array
    @on 'next-page', @nextPage
    @on 'prev-page', @prevPage

  start: =>
    super
    @sortKey = @opts.selectedKeys[0] or 'uid'
    @createTable()
    @paginate()
    @settings({currentPage: @opts.currentPage})
    @createHeader()
    @createRows()
    @createPages()

  # Drawing
  createTable: =>
    table = @opts.selector.append('table')
    @thead = table.append('thead')
    @tbody = table.append('tbody')

  createHeader: =>
    @thead.selectAll('th').remove()

    @thead.selectAll("th")
      .data(@opts.keys)
      .enter().append("th")
        .on('click', (d, i) => @sortRow d)
        .attr('data-key', (d) -> d)
        .text( (d) => "#{@unitsFormatter(@formatKey d)} #{if d is @sortKey then @arrow() else ''}")

  createRows: => 
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

  createPages: =>
    @p.remove() if @p
    @p = d3.select(@selector)
      .append('p')
      .attr('class', 'pages')
      .text("Page: #{parseInt(@opts.currentPage) + 1} of #{@numPages}")

  # Helpers
  paginate: =>
    @numRows = Math.floor((@opts.height - 50 )/ 30) # Assumes thead height of 50px and tbody height of 30px
    @numPages = Math.ceil(@opts.data.length / @numRows)

    sortedData = _.sortBy @opts.data, (d) => d[@sortKey]
    sortedData.reverse() if @opts.sortOrder is 'bottom'
    @pages[number] = sortedData.slice((number * @numRows), ((number + 1) * @numRows)) for number in [0..(@numPages - 1)]

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
    if key is @sortKey
      if @opts.sortOrder is 'top'
        @opts.sortOrder = 'bottom'
      else 
        @opts.sortOrder = 'top'
      @start()
      return
    else
      @opts.sortOrder = 'top'
    @selectKeys [key]
    @start()

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
    @start()

  arrow: =>
    if @opts.sortOrder is 'top'
      return '▲'
    else
      return '▼'

  nextPage: =>
    @currentPage parseInt(@opts.currentPage) + 1
    @start()

  prevPage: =>
    @currentPage parseInt(@opts.currentPage) - 1
    @start()

window.Ubret.Table = Table