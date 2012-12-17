BaseTool = window.Ubret.BaseTool or require('./base_tool')

class Table extends BaseTool
  name: 'Table'
  
  constructor: (opts) ->
    super opts
    @sortOrder = 'top'
    @el.on 'scroll', => console.log 'scrolled'

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
      .data(@page(0))
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
    @numRows = Math.floor((@el.height() - 47 )/ 28)
    @pages = Math.ceil(@dimensions.uid.group().size() / @numRows)

  page: (number) =>
    if number is 0
      top = @dimensions.uid.top(1)[0]
      bottom = @dimensions.uid.top(@numRows)[@numRows - 1]
      return @dimensions.uid.filter(bottom.uid, top.uid).top(Infinity)
    else if number < @pages
      top = @dimensions.uid.top(number * @numRows)[(number * @numRows) - 1]
      bottom = @dimensions.uid.top(number * @numRows)[((number + 1) * @numRows) -1]
      return @imdensions.uid.filter(top.uid, bottom.uid).top(Infinity)

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
    if key is @selectedKey and @sortOrder is 'top'
      @sortOrder = 'bottom'
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