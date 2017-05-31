module ForemanProbingCore
  module Actions
    class UseProbe < ::Dynflow::Action

      def run
        targeting = input[:targeting][:class].constantize.new_from_hash(input[:targeting])
        probe = input[:probe_class].constantize.new(targeting.targets,
                                                    input[:ports],
                                                    input[:options])
        output[:facts] = probe.probe!
      end

      # def rescue_strategy_for_self
      #   Skip
      # end

    end
  end
end
