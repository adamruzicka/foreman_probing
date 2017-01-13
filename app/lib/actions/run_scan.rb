module Actions
  module ForemanProbing
    class RunScan < ::Dynflow::Action

      def plan(target, scan, ports, options = {})
        range = target_to_ips(target)

        plan_self(:from => range.begin, :to => range.end, :ports => ports)
      end

      def run
        range = Range.new(IPAddr.new(input[:from]), IPAddr.new(input[:to]))
        output[:result] = range.map do |ip|

        end
      end

      private

      def scan_to_probe(scan)
        case scan[:type].downcase
        when 'tcp'
          raise NotImplementedError
        when 'udp'
          raise NotImplementedError
        when 'icmp'
          raise NotImplementedError
        end
      end

    end
  end
end