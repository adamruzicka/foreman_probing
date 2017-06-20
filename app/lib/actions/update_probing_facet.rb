module Actions
  module ForemanProbing
    class UpdateProbingFacet < Actions::EntryAction

      def run
        if input.key? :host_id
          host = Host.find(input[:host_id])
          host.probing_facet ||= ::ForemanProbing::ProbingFacet.new
          host.probing_facet.status = input['facts'].fetch('status', {}).fetch('state', 'down')

          %w(tcp udp).each do |protocol|
            update_ports protocol, host.probing_facet
          end

          host.probing_facet.save!
        end
      end

      private

      def update_ports(protocol, facet)
        protocol_base = input['facts'].fetch(:ports, {}).fetch(protocol, {})
        up, down = protocol_base.partition { |number, value| value['state'] == 'open' }
                     .map { |part| part.map(&:first).map(&:to_i) }
        known = facet.scanned_ports.where(:protocol => protocol).pluck(:number)
        to_create = up - known
        to_update = known & up
        to_remove = known & down
        facet.scanned_ports.where(:protocol => protocol, :number => to_remove).delete_all
        facet.scanned_ports.where(:protocol => protocol, :number => to_update).each(&:touch)
        to_create.each do |number|
          facet.scanned_ports << ::ForemanProbing::Port.new(:protocol => protocol, :number => number, :state => protocol_base[number.to_s]['state'])
        end
      end
    end
  end
end
