module Actions
  module ForemanProbing
    class ProcessHost < Actions::EntryAction

      def plan(input)
        sequence do
          parsed_scan = plan_action(::Actions::ForemanProbing::ImportHostFacts,
                                    :scan_id => input[:scan_id],
                                    :facts => input[:facts],
                                    :proxy_id => input[:proxy_id],
                                    :options => input[:options])
          plan_action(::Actions::ForemanProbing::UpdateProbingFacet, parsed_scan.output)
        end
      end
      
    end
  end
end
