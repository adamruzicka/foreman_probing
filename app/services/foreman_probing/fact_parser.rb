module ForemanProbing
  class FactParser < ::FactParser

    attr_reader :facts

    def initialize(facts)
      @facts = HashWithIndifferentAccess.new(facts)
    end

    def domain; end # ?
    
    # We don't know anything about those
    def architecture; end
    def environment; end
    def model; end
    def operatingsystem; end

    def support_interfaces_parsing?
      true
    end

    def ipmi_interface; end

    def get_interfaces # rubocop:disable Style/AccessorMethodName
      count = [4,6].map { |i| facts['addresses'].fetch("ipv#{i}", {}).keys.count }.reduce(:+)
      (0..count - 1).map { |i| "unknown#{i}" }
    end

    def get_facts_for_interface(interface)
      id = interface.match(/unknown(\d+)/)[1].to_i
      # hw, ip = facts['addresses'].partition { |addr| addr['type'] == 'hwaddr' }
      # ipv4, ipv6 = ip.partition { |addr| addr['type'] == 'ipv4' }
      {
        :ipaddress  => facts['addresses'].fetch('ipv4', {}).keys.fetch(id, nil),
        :ip6address => facts['addresses'].fetch('ipv6', {}).keys.fetch(id, nil),
        :macaddress => facts['addresses'].fetch('hwaddr', {}).keys.fetch(id, nil)
      }
    end

  end
end
