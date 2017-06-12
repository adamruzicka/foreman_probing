require 'foreman_tasks_core/shareable_action'

module ForemanProbingCore
  module Actions
    class DiscoverSubnets < ForemanTasksCore::ShareableAction

      def plan(input)
        input[:targets] = get_local_addrs
        probe = plan_action(UseProbe, input)
        input[:result] = probe
        super(input)
      end

      def run
        output = input[:result]
        output[:subnets] = input[:targets]
      end

      private

      def get_local_addrs
        locals = Socket.getifaddrs.select { |ifaddr| ifaddr.addr && ifaddr.addr.ipv4_private? }
        subnets = locals.map do |ifaddr|
          # TODO: This is ugly
          cidr = 32 - ifaddr.netmask.ip_address.to_i.to_s(2).count('1')
          "#{ifaddr.addr.ip_address}/#{cidr}"
        end
      end
      
    end
  end
end
