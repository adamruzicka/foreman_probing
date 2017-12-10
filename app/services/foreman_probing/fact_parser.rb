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
      identifiers = facts['addresses'].values_at(*%w(ipv4 ipv6 hwaddr))
        .compact.map do |hash|
          hash.values.map { |value| value['identifier'] }
        end
      identifiers.flatten.compact.uniq
    end

    def get_facts_for_interface(interface)
      addresses = facts['addresses']
      result = { :ipaddress => 'ipv4',
               :ip6address => 'ipv6',
               :macaddress => 'hwaddr' }.reduce({}) do |acc, (key, kind)|
        acc.merge(key => address_by_identifier(addresses, kind, interface))
      end
      HashWithIndifferentAccess.new(result)
    end

    private

    def address_by_identifier(addresses, kind, identifier)
      addresses.fetch(kind, {}).find { |(_ip, value)| value['identifier'] == identifier }.try(:first)
    end
  end
end
