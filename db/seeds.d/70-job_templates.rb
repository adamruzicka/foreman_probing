if defined?(::JobTemplate)
  User.as_anonymous_admin do
    JobTemplate.without_auditing do
      Dir[File.join("#{ForemanProbing::Engine.root}/app/views/templates/**/*.erb")].each do |template|
        JobTemplate.import_raw!(File.read(template), :default => true, :locked => true, :update => false)
      end
    end
  end
end
