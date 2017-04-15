module Actions
  module ForemanProbing
    class PerformScan < Actions::EntryAction
      include ::Actions::Helpers::WithDelegatedAction

      middleware.do_not_use Dynflow::Middleware::Common::Transaction

      def plan(targets, probe_class, ports, options = {})
        proxy = options[:proxy] || ::ForemanProbing::ProxySelector.new.determine_proxy
        targets = targets.map(&:to_s)
        scan = plan_delegated_action(proxy, ForemanProbingCore::Actions::UseProbe,
                              :targets => targets,
                              :probe_class => probe_class.to_s,
                              :ports => ports, :options => options)
        targets.each do |target|
          parsed_scan = plan_action(::Actions::ForemanProbing::ImportHostFacts, target, scan.output)
          plan_action(::Actions::ForemanProbing::UpdateProbingFacet, parsed_scan)
        end
      end
    end
  end
end
