module ForemanProbing
  class Service < ActiveRecord::Base
    belongs_to :port

    def self.new_from_facts(facts)

    end
  end
end
