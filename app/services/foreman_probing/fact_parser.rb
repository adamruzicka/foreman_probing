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
      count = facts[:addresses].select { |addr| addr["type"] != "hwaddr" }.count
      (0..count - 1).map { |i| "unknown#{i}" }
    end

    def get_facts_for_interface(interface)
      id = interface.match(/unknown(\d+)/)[1].to_i
      hw, ip = facts[:addresses].partition { |addr| addr['type'] == 'hwaddr' }
      ipv4, ipv6 = ip.partition { |addr| addr['type'] == 'ipv4' }
      {
        :ipaddress  => ipv4.fetch(id, {})['addr'],
        :ip6address => ipv6.fetch(id, {})['addr'],
        :macaddress => hw.fetch(id, {})['addr']
      }
    end

  end
end
