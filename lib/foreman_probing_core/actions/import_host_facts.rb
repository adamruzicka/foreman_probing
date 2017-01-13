module ForemanProbingCore
  module Actions
    class ImportHostFacts < ::Dynflow::Action

      def plan(target, scan)
        plan_self(:target => target, :facts => scan[:facts])
      end
      
      def run
        facts = host_facts(input[:target], input[:facts])
        # If we're not scanning an already existing host and it is down, we don't want to import it to Foreman
        unless (input[:host_id].nil? && facts.fetch(:status, {})[:state] == 'down')
          hostname = determine_hostname(facts, input[:target])
          host = Host::Managed.import_host(hostname,
                                           :foreman_probing)
          ::User.as :admin do
            state          = host.import_facts(facts)
            output[:state] = state
          end
        end
      rescue ::Foreman::Exception => e
        # This error is what is thrown by Host#ImportHostAndFacts when
        # the Host is in the build state. This can be refactored once
        # issue #3959 is fixed.
        raise e unless e.code == 'ERF51-9911'
      end

      private

      def host_facts(ip, facts)
        facts.find do |fact|
          fact[:address].map { |h| h[:addr] }.include? ip
        end || {}
      end

      def determine_hostname(facts, fallback)
        # Try to use first of its hostnames, fallback to the ip
        if facts[:hostnames].empty?
          fallback
        else
          facts[:hostnames].first[:name]
        end
      end
    end
  end
end