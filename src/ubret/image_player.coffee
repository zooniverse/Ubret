

class ImagePlayer extends Ubret.BaseTool
  name: 'ImagePlayer'
  
  events:
    'next'      : 'nextPage'
    'prev'      : 'prevPage'
    'selector'  : 'render'
    'data'      : 'dataReceived'
  
  
  constructor: (selector) ->
    _.extend @, Ubret.Sequential
    
    super selector
  
  render: ->
    console.log 'render'
    
    @imagePlayerEl = @d3el.append("div")
      .attr('class', 'image-player')
    
    
  dataReceived: ->
    @d3el.select('canvas').remove()
    
    console.log 'dataReceived'
    data = @preparedData()
    imgUrls = _.pluck(data, 'image')
    @miv = new Ubret.MultiImageView(@imagePlayerEl[0][0], imgUrls)


window.Ubret.ImagePlayer = ImagePlayer
