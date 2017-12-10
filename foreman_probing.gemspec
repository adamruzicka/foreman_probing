require File.expand_path('../lib/foreman_probing/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_probing'
  s.version     = ForemanProbing::VERSION
  # s.date        = Time.zone.today
  s.date        = Time.now
  s.authors     = ['Adam Ruzicka']
  s.email       = ['aruzicka@redhat.com']
  s.homepage    = 'https://github.com/adamruzicka/foreman_probing'
  s.summary     = 'Foreman plugin for detecting network devices'
  # also update locale/gemspec.rb
  s.description = s.summary

  s.files = Dir['{app,config,db,locale}/**/*'] +
            Dir['lib/foreman_probing/**/*'] +
            %w(LICENSE Rakefile README.md lib/foreman_probing.rb)
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_dependency 'foreman-tasks', '~> 0.9'
  s.add_dependency 'dynflow', '~> 0.8'
  # s.add_development_dependency 'rubocop'
  # s.add_development_dependency 'rdoc'
end
