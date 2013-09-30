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
    @subject = @subject || @d3el.append('div').attr('class', 'subject')
    @pageControls = @pageControls || @d3el.append('div').attr('class', 'page-controls')

  render: ({pagedData, currentPage, width}) ->
    @setup()
    @drawButtons({currentPage: currentPage})

    subjectData = pagedData[currentPage]

    attrList = @subject.selectAll('ul')
      .data([subjectData], (d) -> d.uid)
      
    listItems = attrList.enter().append('ul')
      .selectAll('li')
      .data(@toArray, ((d) -> d[1]))

    listItems.enter().append('li')
      .attr('data-key', (d) -> d[1])
      .html((d) => 
        value = if (typeof d[0] isnt 'string') then @format(d[0]) else d[0]
        value = if value is '' then '&nbsp' else value
        console.log(value, d[0]) if d[1] is 'zmag'
        "<label>#{d[1]}:</label><span>#{value}</span>")

    attrList.exit().remove()

    @subject.select('.heading').remove()

    @subject.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

    if _.isArray(subjectData.image)
      images = subject.insert('div.images', ":first-child")
      #new Ubret.MultiImageView(images[0][0], subjectData[0].image)
    else
      @subject.selectAll('img').remove()
      @subject.insert('img', ":first-child")
        .attr('class', 'image')
        .style('width', width - 300 + "px")
        .style('height', width - 300 + "px")
        .attr('src', subjectData.image)

  toArray: (d) =>
    [data] = @state.get('data')
    keys = data.keys()

    _.chain(d).filter((v, k) -> (k in keys) and (v isnt '' and !_.isNaN(v)))
      .zip(keys).value()
          

module.exports = SubjectViewer