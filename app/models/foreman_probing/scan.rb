module ForemanProbing
  class Scan

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :scan_type, :target_kind, :proxy_id

    attr_accessor :direct, :subnet, :host, :tcp, :udp, :icmp, :ports, :use_nmap

    def available_scan_types
      ['TCP', 'UDP', 'ICMP']
    end

    def target_kinds
      ['Direct', 'Subnet', 'Host', 'Proxy']
    end

    def persisted?
      false
    end
  end
end
