module Actions
  module ForemanProbing
    class PerformScan < Actions::EntryAction
      include ::Actions::Helpers::WithContinuousOutput
      include ::Actions::Helpers::WithDelegatedAction

      middleware.do_not_use Dynflow::Middleware::Common::Transaction

      # def plan(proxy, targeting, scan_type, ports, options = {})
      def plan(scan, ports, options = {})
        options[:subnet_discovery] = true if scan.targeting.is_a? ::ForemanProbing::Targeting::SubnetDiscovery
        scanned = plan_delegated_action(scan.smart_proxy, 'ForemanProbingCore::Actions::UseProbe',
                                        :targets => scan.targeting.targets,
                                        :scan_type => scan.scan_type,
                                        :ports => ports,
                                        :options => options)
        subnets = plan_action(CreateSubnets, :proxy_id => scan.smart_proxy_id, :scan => scanned.output) if scan.targeting.is_a? ::ForemanProbing::Targeting::SubnetDiscovery
        plan_action(::Actions::ForemanProbing::ProcessScan,
                    :scan_id  => scan.id,
                    :scan     => scanned.output,
                    :proxy_id => scan.smart_proxy_id,
                    :options  => options)
      end
    end
  end
end
