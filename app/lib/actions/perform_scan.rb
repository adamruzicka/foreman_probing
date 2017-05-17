module Actions
  module ForemanProbing
    class PerformScan < Actions::EntryAction
      include ::Actions::Helpers::WithDelegatedAction

      middleware.do_not_use Dynflow::Middleware::Common::Transaction

      # def plan(targets, probe_class, ports, options = {})
      def plan(targeting, probe_class, ports, options = {})
        proxy = options[:proxy] || ::ForemanProbing::ProxySelector.new.determine_proxy
        scan = plan_delegated_action(proxy, ForemanProbingCore::Actions::UseProbe,
                                     :targeting => targeting.to_hash,
                                     :probe_class => probe_class.to_s,
                                     :ports => ports, :options => options)
        concurrence do
          targeting.enumerate_targets.each do |target, options|
            sequence do
              parsed_scan = plan_action(::Actions::ForemanProbing::ImportHostFacts,
                                        :target => target.to_s,
                                        :facts => facts_for_host(target.to_s, scan.output)
                                        :options => options)
              plan_action(::Actions::ForemanProbing::UpdateProbingFacet, parsed_scan.output)
            end
          end
        end
      end

      private

      def facts_for_host(action, target)
        facts.find do |fact|
          fact[:addresses].values.map(&:keys).flatten.include? ip
        end || {}
      end
    end
  end
end
