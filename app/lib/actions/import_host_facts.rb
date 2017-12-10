module Actions
  module ForemanProbing
    class ImportHostFacts < ::Dynflow::Action
      middleware.use Actions::Middleware::KeepCurrentUser
      def run
        facts = input[:facts]
        # If we're not scanning an already existing host and it is down, we don't want to import it to Foreman
        unless (input[:options][:host_id].nil? && facts.fetch(:status, {})[:state] == 'down')
          host = determine_host(facts)
          facts = try_match_interface_names(host, facts)
          facts.delete(:hostnames)
          ::User.as :admin do
            state          = host.import_facts(facts)
            output[:state] = state
            output[:facts] = facts
          end
          try_set_subnet!(host)
          host.smart_proxy_ids << input[:proxy_id]
          output[:host_id] = host.id
          output[:hostname] = host.name
          scan = ::ForemanProbing::Scan.find(input[:scan_id])
          host.organization_id ||= scan.organization_ids.first
          host.location_id ||= scan.location_ids.first
          host.scans << scan
          host.save!
        end
      rescue ::Foreman::Exception => e
        # This error is what is thrown by Host#ImportHostAndFacts when
        # the Host is in the build state. This can be refactored once
        # issue #3959 is fixed.
        raise e unless e.code == 'ERF51-9911'
      end

      private

      def try_match_interface_names(host, facts)
        names = host.interfaces.where(:mac => facts.fetch(:addresses, {}).fetch(:hwaddr, {}).keys).map(&:identifier)
        if names.count != facts[:addresses][:ipv4].keys.count
          names = facts[:addresses][:ipv4].keys.count.times.map { |i| "unknown#{i}" }
        end
        names.each_with_index do |name, i|
          ip = facts[:addresses][:ipv4].keys[i]
          facts[:addresses][:ipv4][ip][:identifier] = name
        end
        facts
      end

      def try_set_subnet!(host)
        return unless host.subnet.nil? # We don't want to redefine already set subnet
        subnet = if input[:subnet_id]
                   Subnet.find(input[:subnet_id])
                 # TODO: Add middle branch when scanning proxy's subnet
                 else
                   Subnet.all.find { |subnet| subnet.ipaddr.include? host.ip } # Try to find a defined subnet
                 end
        if subnet
          host.location_id = subnet.location_ids.first
          host.organization_id = subnet.organization_ids.first
          host.subnet = subnet
        end
      end

      def determine_host(facts)
        macs = facts[:addresses].fetch(:hwaddr, {}).keys
        unless macs.empty?
          ifaces = ::Nic::Managed.where(:mac => macs)
          return ifaces.first.host unless ifaces.empty?
        end
        Host::Managed.import_host(determine_hostname(facts).dup)
      end

      def determine_hostname(facts)
        # Try to use first of its hostnames, fallback to some of its addresses
        if !facts[:hostnames].empty?
          facts[:hostnames].first[:name]
        else
          name = facts[:addresses].map { |_kind, values| values.keys }.flatten.first
          raise 'Cannot determine host name' if name.nil?
          name
        end
      end
    end
  end
end
