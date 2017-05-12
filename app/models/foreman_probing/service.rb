module ForemanProbing
  class Service < ActiveRecord::Base
    belongs_to :port

    def self.new_from_facts(name, facts)
      service = self.new
      service.name = name
      service.confidence = facts.fetch('confidence', 0)
      service.method = facts.fetch('method', 'table')
      # TODO: Process the rest of the attributes
      service
    end
  end
end
