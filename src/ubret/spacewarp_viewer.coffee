
class SpacewarpViewer extends Ubret.BaseTool
  name: 'SpacewarpViewer'
  
  constructor: (selector) ->
    super selector
    console.log 'SpacewarpViewer', selector


window.Ubret.SpacewarpViewer = SpacewarpViewer