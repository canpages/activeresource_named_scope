# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{arns}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gaius Novus"]
  s.date = %q{2009-05-17}
  s.email = %q{gaius.c.novus@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "README.rdoc", "lib/active_resource", "lib/active_resource/named_scope.rb", "test/named_scope_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/gcnovus/arns}
  s.rdoc_options = ["--line-numbers", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{named_scope for ActiveResource}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
