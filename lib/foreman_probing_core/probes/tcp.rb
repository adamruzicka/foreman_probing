module ForemanProbingCore
  module Probes
    class TCP < Nmap
      def self.scan_type
        'tcp'
      end

      def self.humanized_scan_type
        _('TCP')
      end

      def nmap_flags
        # Use TCP connect scan with service detection
        %w(-sT -sV -T4 -A)
      end
    end
  end
end

