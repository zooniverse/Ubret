fs = require 'fs'
{spawn, exec} = require 'child_process' 
{print} = require 'util'

option '-s', '--server', 'starts node static server on the build directory'
option '-p', '--port [PORT]', 'sets port for server to start on'

Dependencies = [
  'bower_components/d3/d3.js',
  'bower_components/jquery/jquery.js',
  'bower_components/underscore/underscore.js',
  'bower_components/leaflet/leaflet.js'
]

task 'watch', 'Watch src/ for changes', (options) ->
  if options.server
    invoke 'server'
  libu = spawn './node_modules/.bin/coffee', ['-wco', '.', 'src/libu.coffee']
  libu.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  libu.stdout.on 'data', (data) ->
    print data.toString()

  toolsSrcs = fs.readdirSync('./src/tools/').map((f) -> './src/tools/' + f)
  tools = spawn './node_modules/.bin/coffee', ['-wcj', 'tools.js'].concat(toolsSrcs)
  tools.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  tools.stdout.on 'data', (data) ->
    print data.toString()

task 'server', "Serve contents of build", (options) ->
  port = options.port || 3001
  node_static = spawn './node_modules/.bin/static', ['.', '--port', port, '--cache', '0']
  node_static.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  node_static.stdout.on 'data', (data) ->
    print data.toString()
