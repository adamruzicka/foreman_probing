module ForemanProbing
  class FactParser < ::FactParser

    attr_reader :facts

    def initialize(facts)
      @facts = HashWithIndifferentAccess.new(facts[:foreman_probing_facts])
    end

    def domain; end # ?
    
    # We don't know anything about those
    def architecture; end
    def environment; end
    def model; end
    def operatingsystem; end

    def support_interfaces_parsing?
      false
    end

  end
end
