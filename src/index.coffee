window.Ubret = new Object unless typeof window.Ubret isnt 'undefined'

Dependencies = 
  "d3": 
    source: "vendor/d3.js"
  "Leaflet": 
    source: "vendor/leaflet.js"
  "Events" : 
    source: "ubret/events.js"
  "BaseTool": 
    source: "ubret/base_tool.js"
    deps: ["d3"]
  "Graph" :
    source: "ubret/graph.js"
    deps: ["BaseTool"]
  "Histogram" :
    source: "ubret/histogram.js"
    deps: ["Graph"]
  "Scatterplot" :
    source: "ubret/scatterplot.js"
    deps: ["Graph"]
  "SubjectViewer" :
    source: "ubret/subject_viewer.js"
    deps: ["BaseTool"]
  "Mapper" :
    source: "ubret/map.js"
    deps: ["BaseTool", "L"]
  "Statistics" :
    source: "ubret/statistics.js"
    deps: ["BaseTool"]
  "Table" :
    source: "ubret/table.js"
    deps: ["BaseTool"]
  "Spectra" :
    source: "ubret/spectra.js"
    deps: ["BaseTool"]

Ubret.Loader = (tools, cb) ->
  isScriptLoaded = (script) ->
    not (typeof window[script] is 'undefined' or typeof Ubret[script] is 'undefined')

  unique = (array) ->
    uniqueArray = new Array
    for item in array
      unless (item in array) or (typeof item is 'undefined')
        uniqueArray.push item 
    uniqueArray

  dependencies.push Dependencies[tool].deps for tool in tools
  dependencies = unique dependencies