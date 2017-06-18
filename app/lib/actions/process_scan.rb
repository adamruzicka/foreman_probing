module Actions
  module ForemanProbing
    class ProcessScan < Actions::ActionWithSubPlans

      # def plan(scan, proxy_id, options = {})
      #   plan_self(:scan => scan, :proxy_id => proxy_id, :options => options)
      def plan(*args)
        plan_self(*args)
      end

      def create_sub_plans
        input[:scan][:proxy_output][:facts].map do |report|
          trigger(::Actions::ForemanProbing::ProcessHost,
                  :facts => report,
                  :proxy_id => input[:proxy_id],
                  :options => input[:options] || {})
        end
      end
      
    end
  end
end
