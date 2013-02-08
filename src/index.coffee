window.Ubret = new Object unless typeof window.Ubret isnt 'undefined'

Ubret.BaseUrl = if location.port < 1024
  "http://ubret.s3.amazonaws.com/ubret_library/"
else 
  "http://localhost:3001/"

Ubret.Dependencies = 
  "underscore":
    symbol: "_"
    source: "vendor/underscore.js"
  "d3": 
    source: "vendor/d3.js"
  "Leaflet": 
    symbol: "L"
    source: "vendor/leaflet.js"
  "fits":
    source: "vendor/fits.js"
  "Events" : 
    source: "lib/ubret/events.js"
  "BaseTool": 
    source: "lib/ubret/base_tool.js"
    deps: ["Events", "d3", "underscore"]
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
  "SpacewarpViewer" :
    source: "ubret/spacewarp_viewer.js"
    deps: ["BaseTool", "fits"]

Ubret.Loader = (tools, cb) ->
  isScriptLoaded = (script) ->
    not (typeof window[script] is 'undefined' or typeof Ubret[script] is 'undefined')
  
  loadScript = (source, cb=null) ->
    script = document.createElement 'script'
    script.onload = cb
    console.log Ubret.BaseUrl
    script.src = "#{Ubret.BaseUrl}#{source}"
    document.getElementsByTagName('head')[0].appendChild script

  unique = (array) ->
    flattened = []
    flattened = flattened.concat.apply(flattened, array)
    uniqueArray = new Array
    for item in flattened
      unless (item in uniqueArray) or (typeof item is 'undefined')
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
      return
    callback = if tools.length is 1 then cb else loadScripts
    tool = tools.pop()
    unless (isScriptLoaded tool) or (isScriptLoaded Ubret.Dependencies[tool].symbol)
      source = Ubret.Dependencies[tool].source
      loadScript source, callback

  tools = tools.concat findDeps(tools, [])
  loadScripts()