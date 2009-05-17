require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

$LOAD_PATH.unshift("lib")

desc 'Run unit tests'
task :default => :test

test_files_pattern = 'test/**/*_test.rb'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = Dir.glob(test_files_pattern).sort
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

desc 'Calculate test coverage of plugin.'
Rcov::RcovTask.new(:coverage) do |rcov|
  rcov.pattern    = test_files_pattern
  rcov.output_dir = 'coverage'
  rcov.verbose    = true
  rcov.rcov_opts  = ['--sort coverage', '-x "(^/)|(/Gems/)"', '-Ilib']
end