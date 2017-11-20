module ForemanProbingCore
  module Probes
    class Abstract
      class << self
        def scan_type
          raise NotImplementedError
        end

        def humanized_scan_type
          raise NotImplementedError
        end
      end

      def initialize(hosts, ports = [], options = {})
        @hosts   = Array(hosts)
        @ports   = Array(ports)
        @options = options
      end

      def probe!
        raise NotImplementedError
      end
    end
  end
end
