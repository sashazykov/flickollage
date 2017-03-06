Gem::Specification.new do |s|
  s.name        = 'flickollage'
  s.version     = '0.0.4'
  s.date        = '2017-03-05'
  s.summary     = 'Flickollage Collage Generator'
  s.description = 'Flickollage is a simple command line tool for generating collages'
  s.authors     = ['Aleksandr Zykov']
  s.email       = 'alexandrz@gmail.com'
  s.homepage    = 'https://github.com/alexandrz/flickollage'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'thor', '~> 0.19'
  s.add_dependency 'flickraw', '~> 0.9'
  s.add_dependency 'mini_magick', '~> 4.6'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rubocop', '~> 0.47.1'
end
