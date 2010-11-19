require 'lib/weatherbug/version'

spec = Gem::Specification.new do |s|
  
  s.name = 'weatherbug'
  s.author = 'John Crepezzi'
  s.add_development_dependency('rspec')
  s.description = 'Light Wrapper for the WeatherBug partner API'
  s.email = 'john.crepezzi@patch.com'
  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true
  s.homepage = 'http://github.com/seejohnrun/weatherbug'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.summary = 'Ruby WeatherBug partner API'
  s.test_files = Dir.glob('spec/*.rb')
  s.version = WeatherBug::version
  s.rubyforge_project = "weatherbug"

end
