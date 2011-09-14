# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', version: 2, cli: '-cfs'  do
  watch(%r{spec/(.+)\.rb})  { |m| "spec/#{m[1]}.rb" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch('bin/scrabble-solver')  { "spec/" }
end

