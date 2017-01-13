module ForemanProbing
  class Scan < ActiveRecord::Model

    attr_accessor :scan_type, :target_kind

    attr_accessor :direct, :subnet, :host, :tcp, :udp, :icmp, :ports, :use_nmap

    def available_scan_types
      ['UDP', 'TCP', 'ICMP']
    end

    def available_tcp_scan_options
      {
        'Service detection' => 'detect',
        'Service discovery' => 'discover',
        'TCP Open' => 'open'
      }.to_a
    end

    def target_kinds
      ['Direct', 'Subnet', 'Host']
    end

    # TODO: Obtain dynamically
    def known_tcp_services
      ['SSH', 'HTTP']
    end

    def known_udp_services
      ['DNS']
    end

    def icmp_scan_types
      ['ping']
    end
  end
end
