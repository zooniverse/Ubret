# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :input => 'src', :output => 'lib', :all_on_start => true
guard 'coffeescript', :input => 'test/specs', :output => 'test/specsjs', :all_on_start => true
guard 'process', :name => 'Compile Eco', :command => 'eco --output lib/views src/views/' do
  watch(%r{^src\/views\/.+\.eco})
end
