BaseTool = window.Ubret.BaseTool or require('./base_tool')

class SubjectViewer extends BaseTool
  name: 'Subject Viewer'
  
  constructor: (opts) ->
    super
    @count = 0
    @div = d3.select(@selector)
    @start()

  start: =>
    subjects = new Array
    if typeof @selectedElements isnt 'undefined' and @selectedElements.length isnt 0
      subjects = @dimensions.uid.top(Infinity).filter (item) =>
        item.uid in @selectedElements
    else
      subjects = [@dimensions.uid.top(1)[0]]
      @selectElements(_.pluck subjects, 'uid')
    @render(subjects)

  render: (subjects) =>
    @div.selectAll('div.subject').remove()

    subject = @div.selectAll('div')
      .data(subjects).enter()
        .append('div')
        .attr('class', 'subject')

    subject.append('img')
        .attr('src', (d) -> console.log 'here'; d.image)

    subject.selectAll('ul')
      .append('ul')
      .data((d) => @toArray(d)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .text((d) => "#{@formatKey(d[0])}: #{d[1]}")

    subject.select("[data-key=\"#{@selectedKey}\"]")
      .attr('class', 'selected')

  toArray: (data) =>
    arrayedData = new Array
    arrayedData.push [key, data[key]] for key in @keys
    arrayedData

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = SubjectViewer
else
  window.Ubret['SubjectViewer'] = SubjectViewer