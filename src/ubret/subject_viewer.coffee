class SubjectViewer extends Ubret.BaseTool
  name: 'Subject Viewer'
  
  constructor: (selector) ->
    super selector
    @on 'next', @next
    @on 'prev', @prev

  start: =>
    super
    subjects = _(@opts.data).filter (d) => 
      d.uid in @opts.selectedIds

    if _.isEmpty subjects
      @selectIds [@opts.data[0].uid]
      @start()
    else
      @render(subjects)

  render: (subjects) =>
    @div = @opts.selector
    @div.selectAll('div.subject').remove()

    subject = @div.selectAll('div.subject')
      .data(subjects).enter()
        .append('div')
        .attr('class', 'subject')

    subject.append('img')
        .attr('src', (d) -> 
          d.image)

    subject.append('ul').selectAll('ul')
      .data((d) => @toArray(d)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .html((d) => "<label>#{@unitsFormatter(@formatKey(d[0]))}:</label> <span>#{d[2]}</span>")

    subject.select("[data-key=\"#{@selectedKey}\"]")
      .attr('class', 'selected')

    header = subject.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

  toArray: (data) =>
    arrayedData = new Array
    arrayedData.push [key, data[key]] for key in @opts.keys
    arrayedData

window.Ubret.SubjectViewer = SubjectViewer