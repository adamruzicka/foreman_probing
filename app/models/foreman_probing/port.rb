module ForemanProbing
  class Port < ActiveRecord::Base
    belongs_to :probing_facet, :class_name => '::ForemanProbing::ProbingFacet'
    has_many :services

    def self.new_from_facts(protocol, number, facts)
      port = self.new
      port.protocol = protocol
      port.number = number
      port.state = facts[:state]
      port.services = facts["service"].map do |name, hash|
        Service.new_from_hash(name, hash)
      end
      port
    end

    def update_from_port(port)
      protocol = port.protocol
      number = port.number
      state = port.state
      port.services.reject { |service| self.services.map(&:name).include? service.name }.each do |service|
        self.services << service
      end
    end
  end
end
