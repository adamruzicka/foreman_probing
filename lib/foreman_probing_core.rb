require 'dynflow'
require 'foreman_tasks_core'

module ForemanProbingCore
  extend ForemanTasksCore::SettingsLoader

  if ForemanTasksCore.dynflow_present?
    require 'foreman_tasks_core/runner'
  end
  require 'foreman_probing_core/actions'

  def self.use_nmap?
    # TODO:
    # Settings.nmap_enabled &&
    nmap_available?
  end

  def self.nmap_available?
    return @nmap_available unless @nmap_available.nil?
    `nmap`
    @nmap_available = true
  rescue Errno::ENOENT
    @nmap_available = false
  end

  require 'foreman_probing_core/neighbour_cache'
  require 'foreman_probing_core/probes'
  require 'foreman_probing_core/version'
end
