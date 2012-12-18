BaseTool = window.Ubret.BaseTool or require('./base_tool')

class Table extends BaseTool
  name: 'Table'
  
  constructor: (opts) ->
    super opts
    @sortOrder = 'top'
    @currentPage = 0

  start: =>
    super
    @createTable()
    @createHeader()
    @createRows()

  createTable: =>
    table = d3.select(@selector)
      .append('table')
    @thead = table.append('thead')
    @tbody = table.append('tbody')

  createHeader: =>
    @thead.selectAll('th').remove()

    @thead.selectAll("th")
      .data(@keys)
      .enter().append("th")
        .on('click', (d, i) => @selectKey d)
        .attr('data-key', (d) -> d)
        .text( (d) => "#{@formatKey d} #{if d is @selectedKey then @arrow() else ''}")

  createRows: => 
    @paginate()

    @tbody.selectAll('tr').remove()

    unless @selectedKey
      @selectedKey = 'uid'

    tr = @tbody.selectAll('tr')
      .data(@page(@currentPage))
      .enter().append('tr')
        .attr('data-id', (d) -> d.uid)
        .on('click', @selection)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text((d) -> return d)

    if @selectedElements and @selectedElements.length isnt 0
      @highlightRows()

  paginate: =>
    @numRows = Math.floor((@el.height() - 47 )/ 28) # Assumes thead height of 47px and tbody height of 28px
    @pages = Math.ceil(@dimensions.uid.group().size() / @numRows)

  page: (number) =>
    if number is 0
      top = @dimensions[@selectedKey].filterAll()[@sortOrder](1)[0]
      bottom = @dimensions[@selectedKey][@sortOrder](@numRows)[@numRows - 1]
      if @sortOrder is 'top'
        return @dimensions[@selectedKey].filter([bottom[@selectedKey], top[@selectedKey]])[@sortOrder](Infinity)
      else
        return @dimensions[@selectedKey].filter([top[@selectedKey], bottom[@selectedKey]])[@sortOrder](Infinity)
    else if number < @pages
      top = @dimensions[@selectedKey][@sortOrder](number * @numRows)[(number * @numRows) - 1]
      bottom = @dimensions[@selectedKey][@sortOrder](number * @numRows)[((number + 1) * @numRows) -1]
      return @imdensions[@selectedKey].filterAll().filter([bottom[@selectedKey], top[@selectedKey]])[@sortOrder](Infinity)

  toArray: (data) =>
    ret = new Array
    for key in @keys
      ret.push data[key]
    return ret

  highlightRows: =>
    @tbody.select("[data-id=\"#{id}\"]").attr('class', 'selected') for id in @selectedElements

  changeData: (data) =>
    @data = data
    @start()

  selectKey: (key) ->
    if key is @selectedKey 
      if @sortOrder is 'top'
        @sortOrder = 'bottom'
      else if @sortOrder is 'bottom'
        @sortOrder = 'top'
      @start()
      return
    else
      @sortOrder = 'top'
    super key

  selection: (d, i) =>
    ids = @selectedElements
    if d3.event.shiftKey
      index = _.indexOf @selectedElements, d.uid
      if index is -1
        ids.push d.uid
      else
        ids = _.without ids, d.uid 
    else
      ids = [d.uid]
    @selectElements ids

  arrow: =>
    if @sortOrder is 'top'
      return '▲'
    else
      return '▼'

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Table
else
  window.Ubret['Table'] = Table