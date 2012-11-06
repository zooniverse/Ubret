fs = require 'fs'
eco = require 'eco'
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
  coffee_src.stderr.on 'data', (data) -> process.stderr.write data.toString()
  coffee_src.stdout.on 'data', (data) -> print data.toString()

  source_dir = __dirname + '/src/ubret/views/'
  destination_dir = __dirname + '/lib/ubret/views/'

  views = []

  views_func =
    gather_views: (source_dir, working_dir, views) =>
      entities = fs.readdirSync source_dir + working_dir

      entities.forEach (entity) ->
        stats =  fs.statSync(source_dir + working_dir + entity)
        if stats.isDirectory()
          views_func.gather_views(source_dir, working_dir + entity + '/', views)
        else
          views.push working_dir + entity
      views

  views = views_func.gather_views(source_dir, '', views)

  views.forEach (view) ->
    fs.readFile source_dir + view, (err, data) ->
      if (err)
        throw err
      
      template = eco.precompile(data.toString())

      path = view.substr(0, view.lastIndexOf('/') + 1)
      filename = view.substr(view.lastIndexOf('/') + 1)
      filename = filename.replace(/\.(.+)/, '.js')

      templateFile = "module.exports = " + template.toString()
      filepath = destination_dir + path + filename

      fs.writeFile filepath, templateFile, (err) ->
        if (err)
          throw err
          
  
task 'concat', 'Concat lib/ into one js file', ->
  destination_dir = __dirname + '/lib/ubret/'
  singleFile = new String

  singleFile = fs.readFileSync __dirname + '/lib/index.js'

  views_func =
    gather_views: (source_dir, working_dir, views) =>
      entities = fs.readdirSync source_dir + working_dir

      entities.forEach (entity) ->
        stats =  fs.statSync(source_dir + working_dir + entity)
        if stats.isDirectory()
          views_func.gather_views(source_dir, working_dir + entity + '/', views)
        else
          views.push working_dir + entity
      views

  views = []
  views = views_func.gather_views(destination_dir, '', views)

  views.forEach (view) ->
    data = fs.readFileSync destination_dir + view
    singleFile = singleFile + data
  
  fs.writeFileSync __dirname + '/ubret.js', singleFile

