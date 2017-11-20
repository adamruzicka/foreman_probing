module ForemanProbingCore
  module Probes
    class ICMP < Nmap
      def self.scan_type
        'icmp'
      end

      def self.humanized_scan_type
        'ICMP'
      end

      def nmap_flags
        %w(-sn)
      end
    end
  end
end

