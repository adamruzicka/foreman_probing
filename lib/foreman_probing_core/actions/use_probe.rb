module ForemanProbingCore
  module Actions
    class UseProbe < ::Dynflow::Action

      def run
        probe = input[:probe_class].constantize.new(input[:targets],
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
