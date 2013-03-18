class SubjectViewer extends Ubret.BaseTool
  name: 'Subject Viewer'
  
  constructor: ->
    _.extend @, Ubret.Paginated
    super 

  perPage: 1

  pageSort: (data) -> 
    if _.isEmpty @opts.selectedIds
      data
    else
      _.filter data, (d) => 
        d.uid in @opts.selectedIds

  events:
    'next' : 'nextPage'
    'prev' : 'prevPage'
    'data selection next prev' : 'render'

  render: =>
    return if @d3el? and _.isEmpty(@opts.data)
    @d3el.selectAll('div.subject').remove()

    subjectData = @currentPageData()

    subject = @d3el.append('div')
      .attr('class', 'subject')

    subject.append('ul').selectAll('ul')
      .data(@toArray(subjectData)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .html((d) => 
          "<label>#{@unitsFormatter(@formatKey(d[0]))}:</label> 
            <span>#{d[1]}</span>")

    subject.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

    subject.insert('img', ":first-child")
        .attr('src', subjectData[0].image)

  toArray: (data) =>
    data = data[0]
    arrayedData = new Array
    arrayedData.push [key, data[key]] for key in @opts.keys
    arrayedData

window.Ubret.SubjectViewer = SubjectViewer