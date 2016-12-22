require File.expand_path('../lib/foreman_probing_core/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_probing_core'
  s.version     = ForemanProbingCore::VERSION
  # s.date        = Time.zone.today
  s.date        = Time.now
  s.authors     = ['Adam Ruzicka']
  s.email       = ['aruzicka@redhat.com']
  s.homepage    = 'https://github.com/adamruzicka/foreman_probing'
  s.summary     = 'Foreman plugin for detecting network devices, core part'
  # also update locale/gemspec.rb
  s.description = s.summary

  s.files = %w(LICENSE README.md lib/foreman_probing_core.rb) + Dir['lib/foreman_probing_core/**/*']
  # s.test_files = Dir['test/**/*']

  # s.add_dependency 'deface'
  # s.add_development_dependency 'rubocop'
  # s.add_development_dependency 'rdoc'
  s.add_dependency('foreman-tasks-core', '~> 0.1.0')
  s.add_dependency('nokogiri', '~> 1.6.8')
end
