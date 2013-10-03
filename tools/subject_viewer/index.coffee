class SubjectViewer extends U.Tool
  name: 'Subject Viewer'
  className: 'subject-viewer'

  mixins: [require('tools/mixins/sequential')]

  domEvents: {
    'click button' : 'changePage'
  }
  
  constructor: ->
    super 

  setup: ->
    @format = @format || d3.format(',.02f')
    @subjectDiv = @subjectDiv || @d3el.append('div').attr('class', 'subject')
    @pageControls = @pageControls || @d3el.append('div').attr('class', 'page-controls')

  render: ({subject, width}) ->
    @setup()

    attrList = @subjectDiv.selectAll('ul')
      .data([subject], (d) -> d.uid)
      
    listItems = attrList.enter().append('ul')
      .style('width', width - 100 + 'px')
      .selectAll('li')
      .data(@toArray, ((d) -> d[1]))

    listItems.enter().append('li')
      .attr('data-key', (d) -> d[1])
      .html(([value, key]) -> "<label>#{key}:</label><span>#{value}</span>")

    attrList.exit().remove()

    @subjectDiv.select('.heading').remove()

    @subjectDiv.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

    if _.isArray(subject.image)
      images = subject.insert('div.images', ":first-child")
      #new Ubret.MultiImageView(images[0][0], subject[0].image)
    else
      @subjectDiv.selectAll('img').remove()
      @subjectDiv.insert('img', ":first-child")
        .attr('class', 'image')
        .style('width', width - 200 + 'px')
        .attr('src', subject.image)

  toArray: (d) =>
    [data] = @state.get('data')
    keys = data.keys()

    _.chain(d).filter((v, k) -> (k in keys) and v?)
      .filter((v) -> if typeof v is 'string' then v isnt '' else isFinite(v))
      .map(((v) -> if typeof v is 'string' then v else @format(v)), @)
      .zip(keys).value()
          

module.exports = SubjectViewer