require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

$LOAD_PATH.unshift("lib")

desc 'Run unit tests'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = Dir.glob("test/**/*_test.rb" ).sort
  t.verbose = true
end

Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "ARNS -- named_scope for ActiveResource"
  rdoc.main = "README.rdoc"
  rdoc.options << '--line-numbers'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
}