module Actions
  module ForemanProbing
    class UpdateProbingFacet < Actions::EntryAction

      def run
        if input.key? :host_id
          host = Host.find(input[:host_id])
          host.probing_facet ||= ::ForemanProbing::ProbingFacet.new

          [:tcp, :udp].map do |protocol|
            input[:ports].fetch(protocol, {}).map do |port, value|
              port = ::ForemanProbing::Port.new_from_facts(protocol, port, value)
            end
          end
          require 'pry'; binding.pry
        end
      end

    end
  end
end