require 'spec/rake/spectask'
require 'lib/weatherbug/version'
 
task :build  do
  system "gem build weatherbug.gemspec"
end

task :release => :build do
  # tag and push
  system "git tag v#{WeatherBug::version}"
  system "git push origin --tags"
  # push the gem
  system "gem push weatherbug-#{WeatherBug::version}.gem"
end
 
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  fail_on_error = true # be explicit
end
 
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  fail_on_error = true # be explicit
end
