
class Table extends BaseTool

  constructor: (@keys, @data, @selector) ->
    @selectTable()
    @createHeader()
    @createRows()

  selectTable: =>
    @thead = d3.select("#{@selector} thead")
    @tbody = d3.select("#{@selector} tbody")

  createHeader: =>
    @thead.selectAll("th")
      .data(@keys)
      .enter().append("th")
        .on('click', (d, i) => @selectColumn d)
        .attr('data-key', (d) -> d)
        .text( (d) => @formatKey d )

  createRows: (sortAttr='id') =>
    @tbody.selectAll('tr').remove()

    tr = @tbody.selectAll('tr')
      .data(@data)
      .enter().append('tr')
        .sort((a, b) => if a is null || b is null then 0 else @compare a[sortAttr], b[sortAttr])
        .attr('data-id', (d) -> d.id)
        .on('click', (d, i) => @selectRow d)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text( (d) -> return d)

    if @selected?
      @highlightRow()

  compare: (a, b) ->
    if typeof a is 'string'
      return a.localeCompare b
    else
      if a < b then -1 else (if a > b then 1 else 0)

  toArray: (data) =>
    ret = new Array
    for key in @keys
      ret.push data[key]
    return ret

  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  selectColumn: (key) =>
    @createRows key

  selectRow: (datum) => 
    @tbody.select("[data-id=#{@selected}]").attr('class', '') unless typeof @selected is 'undefined'
    @selected = datum.id
    @highlightRow()

  highlightRow: =>
    @tbody.select("[data-id=#{@selected}]").attr('class', 'selected')

  changeData: (data) =>
    @data = data
    @createRows()


if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Table
else
  window.Ubret['Table'] = Table