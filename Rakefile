require 'rspec/core/rake_task'
require File.dirname(__FILE__) + '/lib/weatherbug/version'
 
task :build => :test do
  system "gem build weatherbug.gemspec"
end

task :release => :build do
  # tag and push
  system "git tag v#{WeatherBug::version}"
  system "git push origin --tags"
  # push the gem
  system "gem push weatherbug-#{WeatherBug::version}.gem"
end
 
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.fail_on_error = true
end
 
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov = true
  t.fail_on_error = true
end
