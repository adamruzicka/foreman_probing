require 'rake/testtask'

# Tasks
namespace :foreman_probing do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanProbing'
  Rake::TestTask.new(:foreman_probing) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_probing do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_probing) do |task|
        task.patterns = ["#{ForemanProbing::Engine.root}/app/**/*.rb",
                         "#{ForemanProbing::Engine.root}/lib/**/*.rb",
                         "#{ForemanProbing::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_probing'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_probing']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_probing', 'foreman_probing:rubocop']
end
