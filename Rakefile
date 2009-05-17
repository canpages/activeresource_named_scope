require 'rake'
require 'rake/testtask'

desc 'Run unit tests'
task :default => :test

Rake::TestTask.new do |t|
  t.test_files = Dir.glob("test/**/*_test.rb" ).sort
  t.verbose = true
end