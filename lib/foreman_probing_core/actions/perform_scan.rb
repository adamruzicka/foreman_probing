module ForemanProbingCore
  module Actions
    class PerformScan

      def plan(host, probes, port_overrides)
        probes.each do |probe|
          override = port_overrides.find { |klass, _ports| klass == probe }
          plan_action(UseProbe, host, probe, override)
        end
      end

    end
  end
end
