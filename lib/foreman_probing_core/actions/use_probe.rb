module ForemanProbingCore
  module Actions
    class UseProbe < ::Dynflow::Action
      
      def plan(targets, probe_class, ports, options = {})
        scan = plan_self(:targets => targets.map(&:to_s), :probe_class => probe_class.to_s,
                         :ports => ports, :options => options)
        targets.each do |target|
          plan_action(::ForemanProbingCore::Actions::ImportHostFacts, target.to_s, scan.output)
        end
      end

      def run
        output[:facts] = input[:targets].map do |target|
          probe = input[:probe_class].constantize.new(target, input[:ports], input[:options])
          probe.probe!
        end
      end

      # def rescue_strategy_for_self
      #   Skip
      # end
      
    end
  end
end
