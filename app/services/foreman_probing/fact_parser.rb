module ForemanProbing
  class FactParser < ::FactParser

    attr_reader :facts

    def initialize(facts)
      @facts = HashWithIndifferentAccess.new(facts)
    end
    
    # We don't know anything about those
    def architecture; end
    def domain; end
    def environment; end
    def model; end
    def operatingsystem; end

    def support_interfaces_parsing?
      true
    end

    def ipmi_interface; end

    def get_interfaces # rubocop:disable Style/AccessorMethodName
      # count = [4,6].map { |i| facts['addresses'].fetch("ipv#{i}", {}).keys.count }.reduce(:+)
      # (0..count - 1).map { |i| "unknown#{i}" }
      facts['addresses']['name']
    end

    def get_facts_for_interface(interface)
      index = facts['addresses']['name'].each_with_index.find { |name, _i| name == interface }.last
      HashWithIndifferentAccess.new(:ipaddress  => facts['addresses'].fetch('ipv4', {}).keys.fetch(index, nil),
                                    :ip6address => facts['addresses'].fetch('ipv6', {}).keys.fetch(index, nil),
                                    :macaddress => facts['addresses'].fetch('hwaddr', {}).keys.fetch(index, nil))
    end

  end
end
