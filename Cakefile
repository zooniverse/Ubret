fs = require 'fs'
{spawn} = require 'child_process' 
{print} = require 'util'

task 'build', 'Build lib/ from src', ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'watch', 'Watch src/ for changes', ->
  coffee_src = spawn 'coffee', ['-w', '-c', '-o', 'lib', 'src']
  coffee_src.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee_src.stdout.on 'data', (data) ->
    invoke 'concat'
    print data.toString()

task 'concat', 'Concat lib/ into one js file', ->
  destination_dir = __dirname + '/lib/ubret/'
  singleFile = new String

  singleFile = fs.readFileSync __dirname + '/lib/index.js'
  singleFile = singleFile + fs.readFileSync __dirname + '/lib/ubret/base_tool.js'

  views_func =
    gather_views: (source_dir, working_dir, views) =>
      entities = fs.readdirSync source_dir + working_dir

      entities.forEach (entity) ->
        stats =  fs.statSync(source_dir + working_dir + entity)
        if entity is 'base_tool.js' or entity is 'map.js'
          return
        else if stats.isDirectory()
          views_func.gather_views(source_dir, working_dir + entity + '/', views)
        else
          views.push working_dir + entity
      views

  views = []
  views = views_func.gather_views(destination_dir, '', views)

  views.forEach (view) ->
    data = fs.readFileSync destination_dir + view
    singleFile = singleFile + data
  
  fs.writeFileSync __dirname + '/build/ubret.js', singleFile

