module ForemanProbing
  class StructuredFactImporter < ::StructuredFactImporter
    def fact_name_class
      ForemanProbing::FactName
    end

    def initialize(host, facts = {})
      @host = find_host(host, facts)
      @facts = normalize(facts)
      @counters = {}
    end

    private
    
    def find_host(fallback, facts)
      # TODO: go through facts
      fallback
    end
  end
end
