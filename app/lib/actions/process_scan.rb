module Actions
  module ForemanProbing
    class ProcessScan < Actions::ActionWithSubPlans

      def plan(*args)
        plan_self(*args)
      end

      def create_sub_plans
        input[:scan][:proxy_output][:facts].map do |report|
          trigger(::Actions::ForemanProbing::ProcessHost,
                  :scan_id => input[:scan_id],
                  :facts => report,
                  :proxy_id => input[:proxy_id],
                  :options => input[:options] || {})
        end
      end
      
    end
  end
end
