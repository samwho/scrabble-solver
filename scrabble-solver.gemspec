Gem::Specification.new do |s|
  s.name = %q{scrabble-solver}
  s.version = "0.1"
  s.date = %q{2011-09-08}
  s.authors = ["Sam Rose"]
  s.email = %q{samwho@lbak.co.uk}
  s.summary = %q{A command line Scrabble solving utility.}
  s.homepage = %q{http://github.com/samwho/scrabble-solver}
  s.description = %q{Want to win at Scrabble while staying inside your comfy command line interface? No problem! Scrabble solver lets you do that.}
  s.required_ruby_version = '>= 1.9.2'
  s.license = 'GPL-2'
  s.bindir = 'bin'
  s.executables = ["scrabble-solver"]

  # Add all files to the files parameter.
  s.files = []
  Dir["**/*.*"].each { |path| s.files.push path }
  s.files.push ".gemtest"
end
