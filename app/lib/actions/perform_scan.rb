module Actions
  module ForemanProbing
    class PerformScan < Actions::EntryAction
      include ::Actions::Helpers::WithContinuousOutput
      include ::Actions::Helpers::WithDelegatedAction

      middleware.do_not_use Dynflow::Middleware::Common::Transaction

      def plan(proxy, targeting, scan_type, ports, options = {})
        options[:subnet_discovery] = true if targeting.is_a? ::ForemanProbing::Targeting::SubnetDiscovery
        scan = plan_delegated_action(proxy, 'ForemanProbingCore::Actions::UseProbe',
                                     :targets => targeting.targets,
                                     :scan_type => scan_type,
                                     :ports => ports,
                                     :options => options)
        subnets = plan_action(CreateSubnets, :proxy_id => proxy.id, :scan => scan.output) if targeting.is_a? ::ForemanProbing::Targeting::SubnetDiscovery
        plan_action(::Actions::ForemanProbing::ProcessScan,
                    :scan => scan.output,
                    :proxy_id => proxy.nil? ? nil : proxy.id,
                    :options => options)
      end
    end
  end
end
