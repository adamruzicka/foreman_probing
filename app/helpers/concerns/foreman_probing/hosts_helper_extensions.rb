module ForemanProbing
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
      # alias_method_chain(:host_title_actions, :run_button)
      alias_method_chain :multiple_actions, :probing
    end

    def multiple_actions_with_progin
      multiple_actions_without_probing + [[_('Probe'), new_job_invocation_path, false]]
    end
  end
end
