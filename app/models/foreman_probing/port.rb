module ForemanProbing
  class Port < ActiveRecord::Base
    belongs_to :probing_facet, :class_name => '::ForemanProbing::ProbingFacet'
    has_many :services

    def self.new_from_facts(protocol, number, facts)
      port = self.new
      port.protocol = protocol
      port.number = number
      port.state = facts[:state]
    end
  end
end
