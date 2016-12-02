require 'foreman_tasks_core'

module ForemanProbingCore
  extend ForemanTasksCore::SettingsLoader

  if ForemanTasksCore.dynflow_present?
    require 'foreman_tasks_core/runner'
  end

  require 'foreman_probing_core/service_probes'

  require 'foreman_probing_core/version'

end
