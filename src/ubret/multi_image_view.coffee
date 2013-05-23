class MultiImageView

  # @el should either be a query string or a document element
  constructor: (@el, @imageSrcs, @height, @width) ->
    @index = 0
    if typeof @el is 'string'
      @el = document.querySelector(@el)[0]
    @preloadImages()

  newImages: (imageSrcs) =>
    @imageSrcs = imageSrcs
    @preloadImages()

  preloadImages: =>
    @images = []
    loadedImages = 0

    inc = => 
      loadedImages += 1
      if (loadedImages is @imageSrcs.length)
        @render()

    for src in @imageSrcs
      img = new Image
      img.src = src
      img.onload = inc
      @images.push img

  drawImage: => 
    @ctx = @ctx or @canvas.getContext('2d')
    @ctx.drawImage(@images[@index], 0, 0) 

  play: =>
    @animateImages = true
    @animate()

  stop: =>
    @animateImages = false

  animate: =>
    return unless @animateImages
    @index += 1
    @index = 0 if @index >= @images.length
    @drawImage()
    setTimeout(@animate, 750)

  createCanvas: =>
    canvas = document.createElement('canvas')
    canvas.setAttribute('class', 'image')
    canvas.setAttribute('height', @height or @images[0].height)
    canvas.setAttribute('width', @height or @images[0].width)
    @el.appendChild canvas
    canvas.addEventListener('mouseover', @play, true)
    canvas.addEventListener('mouseout', @stop, true)
    canvas

  render: =>
    @canvas = @canvas or @createCanvas()
    @drawImage()

window.Ubret.MultiImageView = MultiImageView
