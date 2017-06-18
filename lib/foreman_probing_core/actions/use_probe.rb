require 'foreman_tasks_core/shareable_action'

module ForemanProbingCore
  module Actions
    class UseProbe < ForemanTasksCore::ShareableAction

      def plan(input)
        if input.fetch('options', {})['subnet_discovery']
          input['local_addresses'] = get_local_addrs
          input['targets'] = input['local_addresses'].keys
        end
        super(input)
      end

      def run
        probe = probe_class.new(input[:targets],
                                input[:ports],
                                input[:options])
        output[:targets] = input[:targets]
        output[:local_addresses] = input[:local_addresses] if input.key? :local_addresses
        output[:facts] = probe.probe!
      end

      private

      def probe_class
        case input[:scan_type].downcase
        when 'tcp'
          ForemanProbingCore::Probes::TCP
        when 'udp'
          ForemanProbingCore::Probes::UDP
        when 'icmp'
          ForemanProbingCore::Probes::ICMP
        else
          raise "Unknown scan_type '#{input[:scan_type]}'"
        end
      end

      def get_local_addrs
        locals = Socket.getifaddrs.select { |ifaddr| ifaddr.addr && ifaddr.addr.ipv4_private? }
        subnets = locals.reduce({}) do |acc, ifaddr|
          # TODO: This is ugly
          cidr = 32 - ifaddr.netmask.ip_address.to_i.to_s(2).count('1')

          acc.merge("#{ifaddr.addr.ip_address}/#{cidr}" => { :addr => ifaddr.addr.ip_address,
                                                             :netmask => ifaddr.netmask.ip_address,
                                                             :cidr => cidr })
        end
      end

    end
  end
end
