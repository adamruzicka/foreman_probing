require 'ipaddr'

module ForemanProbingCore
  module Probes
    class Abstract

      include ForemanProbingCore::Helpers::NmapHelper

      COMMON_PORTS = []

      class << self
        def scan_type
          raise NotImplementedError
        end

        def humanized_scan_type
          raise NotImplementedError
        end

        def service_name
          self.to_s.downcase
        end

        def humanized_service_name
          self.to_s
        end
      end

      def initialize(hosts, ports = COMMON_PORTS, options = {})
        hosts    = Array(hosts)
        @hosts   = hosts.map { |host| IPAddr.new(host) }
        @ports   = Array(ports)
        @options = options
      end

      def probe!
        nmap_probe
      end
    end

    class TCPProbe < Abstract
      def self.scan_type
        'tcp'
      end

      def self.humanized_scan_type
        _('TCP')
      end

      def nmap_flags
        # Use TCP connect scan with service detection
        %w(-sT -sV)
      end
    end

    class UDPProbe < Abstract
      def self.scan_type
        'udp'
      end

      def self.humanized_scan_type
        _('UDP')
      end

      def nmap_flags
        # Use UDP scan with service detection
        %w(-sU -sV)
      end
    end

  end
end
