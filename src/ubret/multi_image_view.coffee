class MultiImageView

  constructor: (@el, @imageSrcs, @onReady) ->
    @preloadImages()

  preloadImages: =>
    @images = []
    loadedImages = 0

    inc = => 
      loadedImages += 1
      if (loadedImages is @imageSrcs.length)
        @onReady()

    for src in @imageSrcs
      img = new Image
      img.src = src
      img.onload = inc
      @images.push img

  render: =>
    d3.select(@el).
      .append('img').attr('src')


window.Ubret.MultiImageView = MultiImageView
