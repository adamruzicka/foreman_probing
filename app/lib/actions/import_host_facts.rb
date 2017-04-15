module Actions
  module ForemanProbing
    class ImportHostFacts < ::Dynflow::Action

      def plan(target, scan)
        plan_self(:target => target, :facts => scan[:facts])
      end
      
      def run
        facts = host_facts(input[:target], input[:facts])
        # If we're not scanning an already existing host and it is down, we don't want to import it to Foreman
        unless (input[:host_id].nil? && facts.fetch(:status, {})[:state] == 'down')
          host = determine_host(facts)
          ::User.as :admin do
            state          = host.import_facts(facts)
            output[:state] = state
            output[:facts] = facts
          end
          output[:host_id] = host.id
          output[:hostname] = host.name
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
          fact[:addresses].values.map(&:keys).flatten.include? ip
        end || {}
      end

      def determine_host(facts)
        macs = facts[:addresses].fetch(:hwaddr, {}).keys
        unless macs.empty?
          ifaces = ::Nic::Managed.w5here(:mac => macs)
          return ifaces.first.host unless ifaces.empty?
        end
        Host::Managed.import_host(determine_hostname(facts, input[:target]), :foreman_probing)
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
