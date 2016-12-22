require 'foreman_tasks_core'

module ForemanProbingCore
  extend ForemanTasksCore::SettingsLoader

  if ForemanTasksCore.dynflow_present?
    require 'foreman_tasks_core/runner'
  end

  def self.can_use_nmap?
    # TODO:
    # Settings.nmap_enabled &&
    nmap_available?
  end

  def self.nmap_available?
    # TODO:

    return @nmap_available unless @nmap_available.nil?
    `nmap`
    @nmap_available = true
  rescue Errno::ENOENT
    @nmap_available = false
  end

  require 'foreman_probing_core/helpers'
  require 'foreman_probing_core/service_probes'

  require 'foreman_probing_core/version'

end
