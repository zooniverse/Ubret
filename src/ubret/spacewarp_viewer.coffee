
class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  
  constructor: (selector) ->
    super selector

  start: =>
    super
    console.log 'from start', @opts
    
window.Ubret.SpacewarpViewer = SpacewarpViewer