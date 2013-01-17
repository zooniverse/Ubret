BaseTool = window.Ubret.BaseTool

class SubjectViewer extends BaseTool
  name: 'Subject Viewer'
  
  constructor: (opts) ->
    super
    @count = 0

  start: =>
    if @opts.selectedIds.length is 0
      @selectIds [@opts.data.first.uid]
    subjects = _(@opts.data).filter (d) => 
      d.uid in @opts.selectedIds
    @render(subjects)

  render: (subjects) =>
    @div = d3.select(@selector)
    @div.selectAll('div.subject').remove()

    subject = @div.selectAll('div.subject')
      .data(subjects).enter()
        .append('div')
        .attr('class', 'subject')

    subject.append('img')
        .attr('src', (d) -> d.image)

    subject.append('ul').selectAll('ul')
      .data((d) => @toArray(d)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .html((d) => "<label>#{@formatKey(d[0])}:</label> <span>#{d[1]}</span>")

    subject.select("[data-key=\"#{@selectedKey}\"]")
      .attr('class', 'selected')

    header = subject.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

  toArray: (data) =>
    arrayedData = new Array
    arrayedData.push [key, data[key]] for key in @keys
    arrayedData

window.Ubret.SubjectViewer = SubjectViewer