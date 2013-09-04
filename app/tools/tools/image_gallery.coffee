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
    @d3el.selectAll('div.images img').remove()
    @d3el.selectAll('div.selection img').remove()

    @images = @images or @d3el.append('div').attr('class', 'images')

    @images.selectAll('img')
      .data(@toArray(@currentPageData()))
      .enter().append('img')
        .attr('src', (d) -> d[1]).attr('data-uid', (d) -> d[0])
        .attr('class', (d) =>
          if @firstSelected()?.uid is d[0]
            'selected'
          else
            '')
        .on('click', (d, i) => @selectIds([d[0]]))
    
    @selection = @selection or @d3el.append('div').attr('class', 'selection')

    if _.isArray(@firstSelected()?.image)
      @multiViewer = @multiViewer?.newImages(@firstSelected()?.image) or 
        new Ubret.MultiImageView(@selection[0][0], @firstSelected()?.image)
    else
      @selection.append('img').attr('src', @firstSelected()?.image)

  firstSelected: =>
    _.filter(@preparedData(), (d) => 
      d.uid in @opts.selectedIds)[0]

  toArray: (data) =>
    _.map data, (d) -> [d.uid, d.thumb]

window.Ubret.ImageGallery = ImageGallery
