class ImageGallery extends Ubret.BaseTool
  name: 'Image Gallery'

  constructor: ->
    _.extend @, Ubret.Paginated
    super

  events:
    'next' : 'nextPage render'
    'prev' : 'prevPage render'
    'data' : 'render'
    'selection' : 'render'
    'width' : 'render'

  # Pagination
  perPage: ->
    Math.floor(@opts.width / 110)

  pageSort: (data) ->
    data

  render: =>
    return if @d3el? and _.isEmpty(@preparedData())
    @d3el.selectAll('div.images').remove()
    @d3el.selectAll('div.selection').remove()

    @images = @d3el.append('div').attr('class', 'images')
      .selectAll('img')
      .data(@toArray(@currentPageData()))
      .enter().append('img')
        .attr('src', (d) -> d[1]).attr('data-uid', (d) -> d[0])
        .attr('class', (d) =>
          if @firstSelected().uid is d[0]
            'selected'
          else
            '')
        .on('click', (d, i) => @selectIds([d[0]]))
    
    @d3el.append('div').attr('class', 'selection')
      .append('img').attr('src', @firstSelected().image)

  firstSelected: =>
    _.filter(@preparedData(), (d) => 
      d.uid in @opts.selectedIds)[0]

  toArray: (data) =>
    _.map data, (d) -> [d.uid, d.image]

window.Ubret.ImageGallery = ImageGallery
