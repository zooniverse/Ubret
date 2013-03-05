class SubjectViewer extends Ubret.Sequential
  name: 'Subject Viewer'
  
  constructor: ->
    super 

  events:
    'next' : 'next'
    'prev' : 'prev'
    'keys data selection next-selected prev-selected' : 'render'

  render: =>
    unless @opts.selector? and (not _.isEmpty @opts.data) then return
    @selectSubject()
    @div = @opts.selector
    @div.selectAll('div.subject').remove()

    subject = @div.selectAll('div.subject')
      .data(@subject).enter()
        .append('div')
        .attr('class', 'subject')

    subject.append('img')
        .attr('src', (d) -> 
          d.image)

    subject.append('ul').selectAll('ul')
      .data((d) => @toArray(d)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .html((d) => "<label>#{@unitsFormatter(@formatKey(d[0]))}:</label> <span>#{d[1]}</span>")

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