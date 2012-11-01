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
  coffee_src.stderr.on 'data', (data) -> process.stderr.write data.toString()
  coffee_src.stdout.on 'data', (data) -> print data.toString()
  
task 'concat', 'Concat lib/ into one js file', ->
  singleFile = new String

  singleFile = fs.readFileSync __dirname + '/lib/index.js'

  fs.readdir __dirname + '/lib/ubret/', (err, files) ->
    throw err if err
    files.forEach (file) ->
      data = fs.readFileSync __dirname + '/lib/ubret/' + file
      singleFile = singleFile + data
    fs.writeFileSync __dirname + '/ubret.js', singleFile