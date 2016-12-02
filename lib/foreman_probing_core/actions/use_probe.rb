module ForemanProbingCore
  module Actions
    class UseProbe < ::Dynflow::Action
      
      def plan(host, probe_class, probe_overrides = nil)
        ports = probe_overrides.nil? ? probe_class::COMMON_PORTS : probe_overrides
        plas_self :host => host, :ports => ports, :probe_class => probe_class
      end

      def run
        probe = input[:probe].constantize.new(input[:host], ports)
        output[:result] = probe.probe!
      end

      def finalize
        if output[:result][:state] != :valid
          raise "Probe failed"
        end
      end

      def rescue_strategy_for_self
        Skip
      end
      
    end
  end
end
