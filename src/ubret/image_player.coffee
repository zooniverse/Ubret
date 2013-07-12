

class ImagePlayer extends Ubret.BaseTool
  name: 'ImagePlayer'
  
  events:
    'next'                : 'nextPage onNext'
    'prev'                : 'prevPage onPrev'
    'selector'            : 'render'
    'data'                : 'dataReceived'
    'setting:isPlaying'   : 'onPlayPause'
    'setting:imageIndex'  : 'onReset'
  
  
  constructor: (selector) ->
    _.extend @, Ubret.Sequential
    
    super selector
    @imageIndex = null
    @intervalId = null
  
  render: ->
    console.log 'render'
    
    @imagePlayerEl = @d3el.append("canvas")
      .attr('class', 'image-player')
    
  dataReceived: =>
    @subjects = @preparedData()
    
    @canvas = @imagePlayerEl[0][0]
    @context = @canvas.getContext('2d')
    
    # Check if query returned images
    return if @subjects.length is 0
    
    # Load image using imageIndex setting
    @imageIndex = @opts.imageIndex or 0
    
    @drawImage()
    # @miv = new Ubret.MultiImageView(@imagePlayerEl[0][0], imgUrls)
  
  drawImage: ->
    src = @subjects[ @imageIndex ].image
    
    img = new Image()
    img.onload = (e) =>
      @canvas.width = img.width
      @canvas.height = img.height
      @context.drawImage(img, 0, 0)
    img.src = src
    
  onPlayPause: (e) =>
    
    if @subjects?
      
      console.log 'isPlaying', @opts.isPlaying
      if @opts.isPlaying
        @intervalId = setInterval ( =>
          unless @onNext()
            clearInterval(@intervalId) if @intervalId?
            @settings({isPlaying: false})
        ), 300
  
  onReset: (e) =>
    if @subjects?
      @imageIndex = @opts.imageIndex
      @drawImage()
    
  onNext: =>
    return false if @subjects.length is 0
    return false if @imageIndex is (@subjects.length - 1)
    
    @imageIndex += 1
    @settings({imageIndex: @imageIndex})
    @drawImage()
    return true
  
  onPrev: =>
    return false if @subjects.length is 0
    return false if @imageIndex is 0
    
    @imageIndex -= 1
    @settings({imageIndex: @imageIndex})
    @drawImage()
    return true
  
  
window.Ubret.ImagePlayer = ImagePlayer
