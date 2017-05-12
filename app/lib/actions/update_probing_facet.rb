module Actions
  module ForemanProbing
    class UpdateProbingFacet < Actions::EntryAction

      def run
        if input.key? :host_id
          host = Host.find(input[:host_id])
          host.probing_facet ||= ::ForemanProbing::ProbingFacet.new

          %w(tcp udp).each do |protocol|
            update_ports protocol, host.probing_facet
          end
        end
      end

      private

      def update_ports(protocol, facet)
        protocol_base = input["facts"].fetch(:ports, {}).fetch(protocol, {})
        up, down = protocol_base.partition { |number, value| value["state"] == 'open' }
                     .map { |part| part.map(&:first) }
        known = facet.scanned_ports.where(:protocol => protocol).pluck(:number)
        to_create = up - known
        to_update = known & up
        to_remove = known & down
        require 'pry'; binding.pry
        facet.scanned_ports.where(:protocol => protocol, :number => to_remove).delete_all
        # TODO: Maybe change something more than the timestamp?
        facet.scanned_ports.where(:protocol => protocol, :number => to_update).each(&:touch)
        to_create.each do |number|
          port = ::ForemanProbing::Port.new_from_facts(protocol, port, value)
          facet.scanned_ports << port
        end
      end
    end
  end
end
