require 'deface'

module ForemanProbing
  class Engine < ::Rails::Engine
    engine_name 'foreman_probing'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/services"]
    config.autoload_paths += Dir["#{config.root}/app/lib/"]
    config.autoload_paths += Dir["#{config.root}/app/lib/actions"]

    initializer 'foreman_probing.apipie' do
      Apipie.configuration.api_controllers_matcher << "#{ForemanProbing::Engine.root}/app/controllers/foreman_probing/api/v2/*.rb"
      Apipie.configuration.checksum_path += ['/foreman_probing/api/v2/']
    end

    # Add any db migrations
    initializer 'foreman_probing.load_app_instance_data' do |app|
      ForemanProbing::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_probing.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_probing do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_probing do
          permission :view_foreman_probing_open_ports, :hosts => [:open_ports], :resource_type => 'Host'
        end

        # Add a new role called 'Discovery' if it doesn't exist
        # role 'ForemanProbing', [:view_foreman_probing]

        menu :top_menu, :template,
             url_hash: { controller: :'foreman_probing/scans', action: :index },
             caption: _('Network scans'),
             parent: :monitor_menu,
             after: :audits


        # add dashboard widget
        # widget 'foreman_probing_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_probing.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_probing.configure_assets', group: :assets do
      SETTINGS[:foreman_probing] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:prepend, ForemanProbing::HostExtensions)
        ForemanTasks::Task.send(:prepend, ForemanProbing::ForemanTasksTaskExtensions)
        HostsHelper.send(:prepend, ForemanProbing::HostsHelperExtensions)

        ::FactImporter.register_fact_importer(
          :foreman_probing,
          ForemanProbing::StructuredFactImporter
        )
        ::FactParser.register_fact_parser(:foreman_probing, ForemanProbing::FactParser)
      rescue => e
        Rails.logger.warn "ForemanProbing: skipping engine hook (#{e})"
      end
    end

    config.to_prepare do
      Facets.register(ForemanProbing::ProbingFacet) do
        # extend_model PuppetHostExtensions
        # add_helper PuppetFacetHelper
        # add_tabs :puppet_tabs
        # api_view :list => 'api/v2/puppet_facets/base', :single => 'api/v2/puppet_facets/single_host_view'
        # template_compatibility_properties :environment_id, :puppet_proxy_id, :puppet_ca_proxy_id
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanProbing::Engine.load_seed
      end
    end

    initializer 'foreman_probing.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_probing'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer 'foreman_probing.require_dynflow', :before => 'foreman_tasks.initialize_dynflow' do |app|
      ForemanTasks.dynflow.require!
      ForemanTasks.dynflow.config.eager_load_paths << File.join(ForemanProbing::Engine.root, 'app/lib/actions')
    end

    initializer 'foreman_probing.register_paths' do |_app|
      ForemanTasks.dynflow.config.eager_load_paths.concat(%W[#{ForemanProbing::Engine.root}/app/lib/actions}])
    end
  end

  def self.table_name_prefix
    'foreman_probing_'
  end

  def use_relative_model_naming
    true
  end
end
