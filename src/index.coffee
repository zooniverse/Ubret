window.Ubret = {} unless typeof window.Ubret isnt 'undefined'

Ubret.BaseUrl = if location.port < 1024
  "http://ubret.s3.amazonaws.com/ubret_library/"
else 
  "http://localhost:3001/"

Ubret.Dependencies = 
  "underscore":
    symbol: "_"
    source: "vendor/underscore.js"
  "Backbone":
    symbol: "Backbone"
    source: "vendor/backbone.js"
    deps: ["underscore"]
  "d3": 
    source: "vendor/d3.js"
  "d3.units":
    source: "vendor/d3.units.js"
    deps: ["d3"]
  "Leaflet": 
    symbol: "L"
    source: "vendor/leaflet.js"
  "fits":
    source: "vendor/fits.js"
  "Events" : 
    source: "lib/ubret/events.js"
  "BaseTool": 
    source: "lib/ubret/base_tool.js"
    deps: ["Events", "underscore", "d3.units"]
  "Graph" :
    source: "lib/ubret/graph.js"
    deps: ["BaseTool"]
  "Histogram" :
    source: "lib/ubret/histogram.js"
    deps: ["Graph"]
  "Scatterplot" :
    source: "lib/ubret/scatterplot.js"
    deps: ["Graph"]
  "SubjectViewer" :
    source: "lib/ubret/subject_viewer.js"
    deps: ["BaseTool"]
  "Mapper" :
    source: "lib/ubret/map.js"
    deps: ["BaseTool", "Leaflet"]
  "Statistics" :
    source: "lib/ubret/statistics.js"
    deps: ["BaseTool"]
  "Table" :
    source: "lib/ubret/table.js"
    deps: ["BaseTool"]
  "Spectra" :
    source: "lib/ubret/spectra.js"
    deps: ["BaseTool"]
  "SpacewarpViewer":
    source: "lib/ubret/spacewarp_viewer/initialize.js"
    deps: ["Backbone", "fits", "BaseTool"]

Ubret.Loader = (tools, cb) ->
  isScriptLoaded = (script) ->
    return (window[script]? or Ubret[script]?)
    
  loadScript = (source, cb=null) ->
    script = document.createElement 'script'
    script.onload = cb
    script.src = "#{Ubret.BaseUrl}#{source}?t=#{new Date().getMilliseconds()}"
    document.getElementsByTagName('head')[0].appendChild script

  unique = (array) ->
    flattened = []
    flattened = flattened.concat.apply(flattened, array)
    uniqueArray = new Array
    for item in flattened
      continue unless item?
      unless item in uniqueArray
        uniqueArray.push item 
    uniqueArray

  findDeps = (deps, accum) ->
    dependencies = []
    for dep in deps when Ubret.Dependencies
      dependencies.push Ubret.Dependencies[dep].deps
    dependencies = unique dependencies
    if dependencies.length is 0
      return unique accum
    else
      return findDeps(dependencies, accum.concat(dependencies))

  loadScripts = ->
    if tools.length is 0 
      cb()
      return
    callback = loadScripts
    tool = tools.pop()
    unless (isScriptLoaded tool) or (isScriptLoaded Ubret.Dependencies[tool]?.symbol)
      source = Ubret.Dependencies[tool].source
      loadScript source, callback
    else
      loadScripts()

  tools = tools.concat findDeps(tools, [])
  loadScripts()
