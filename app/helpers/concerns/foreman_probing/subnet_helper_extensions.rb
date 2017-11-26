module ForemanProbing
  module SubnetHelperExtensions
    def multiple_actions
      super + [[_('Probe'), new_job_invocation_path, false]]
    end
  end
end
