module ForemanProbingCore
  module Probes
    class UDP < Nmap
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

