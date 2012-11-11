BaseTool = window.Ubret.BaseTool or require('./base_tool')

class Table extends BaseTool

  constructor: (opts) ->
    super opts
    @createTable()
    @start()

  start: =>
    @createHeader()
    @createRows()

  createTable: =>
    table = d3.select(@selector)
      .append('table')
    @thead = table.append('thead')
    @tbody = table.append('tbody')

  createHeader: =>
    @thead.selectAll("th")
      .data(@keys)
      .enter().append("th")
        .on('click', (d, i) => @selectKey d)
        .attr('data-key', (d) -> d)
        .text( (d) => @formatKey d )

  createRows: => 
    @tbody.selectAll('tr').remove()

    tr = @tbody.selectAll('tr')
      .data(@dimensions[@selectedKey].top(Infinity))
      .enter().append('tr')
        .attr('data-id', (d) -> d.id)
        .on('click', @selection)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text( (d) -> return d)

    if @selectedElements
      @highlightRows()

  toArray: (data) =>
    ret = new Array
    for key in @keys
      ret.push data[key]
    return ret

  highlightRows: =>
    @tbody.select("[data-id=#{id}]").attr('class', 'selected') for id in @selectedElements

  changeData: (data) =>
    @data = data
    @createRows()

  selection: (d, i) =>
    ids = @selectedElements
    if d3.event.shiftKey
      index = _.indexOf @selectedElements, d.id
      if index is -1
        ids.push d.id
      else
        ids = _.without ids, d.id 
    else
      ids = [d.id]
    @selectElements ids

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Table
else
  window.Ubret['Table'] = Table