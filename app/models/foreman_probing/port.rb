module ForemanProbing
  class Port < ActiveRecord::Base
    belongs_to :probing_facet, :class_name => '::ForemanProbing::ProbingFacet'
    has_many :services

    def update_from_facts(protocol, number, facts)
      self.protocol = protocol
      self.number = number
      self.state = facts[:state]
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
