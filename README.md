Ubret
=====

RAILS_ENV=development foreman start
rails s

## Development
Currently the Ubrets are divided into two branches the master branch holds the Ubret npm module that makes it include-able into other projects. To do development on this branch, be sure to do a `bundle install` and a `bundle exec guard` this will ensure that coffeescripts are being compiled to js as you program. 

The Dashboard branch holds the web interface we've currently been working on. This should really be split into a seperate git repo at some point. 