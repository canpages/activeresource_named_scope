require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'
require 'rake/gempackagetask'

$LOAD_PATH.unshift("lib")
require 'active_resource/named_scope'

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

spec = Gem::Specification.new do |s|
  s.name = "arns"
  s.version = ActiveResource::NamedScope::VERSION
  s.summary = "named_scope for ActiveResource"
  s.homepage = "http://github.com/gcnovus/arns"
 
  s.files = FileList['[A-Z]*', '{lib,test}/**/*']
 
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--line-numbers", "--main", "README.rdoc"]
 
  s.authors = ["Gaius Novus"]
  s.email = "gaius.c.novus@gmail.com"
end

Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Generate a gemspec file for GitHub"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end