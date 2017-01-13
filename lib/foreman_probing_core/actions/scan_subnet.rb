module Actions
  module ForemanProbingCore
    class ScanSubnet < ::Dynflow::Action

      def plan(subnet, probes = [ServiceProbes::TCPOpen], port_overrides = {})
        probes.each do |probe|
          plan_action(UseProbe, subnet, probe, port_overrides[probe])
        end
      end

    end
  end
end