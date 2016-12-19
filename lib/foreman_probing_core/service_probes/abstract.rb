module ForemanProbingCore
  module ServiceProbes

    class ResultBuilder

      attr_reader :result

      def initialize(host)
        @host = host
        @result = {
          :address => { "addr" => @host },
          :status => {},
          :hostnames => {},
          :ports = []
        }
      end

      def exception(exception)
        status = { :state => :exception,
          :exception => {
            :class     => exception.class,
            :message   => exception.message,
            :backtrace => exception.backtrace }
        }
        @result[:status].update(:state => status)        
      end

      def host_state(state, reason = 'probe')
        @result[:status].update(:state => state, :reason => reason)
        self
      end

      def port_state(protocol, number, state, service = nil, service_meta = {})
        data = {
          'protocol' => protocol,
          'portid' => number,
          'state' => { 'state' => state }
        }
        data.update('service' => { 'name' => service, 'meta' => service_meta }) if service
        @result[:ports] << data
        @result[:ports].uniq!
        self
      end
    end

    class Abstract

      include ForemanProbingCore::Helpers::NmapHelper

      COMMON_PORTS = []

      def initialize(host, ports = COMMON_PORTS, options = {})
        @host    = host
        @ports   = ports
        @options = options
        @result_builder = ResultBuilder.new(host)
      end

      def probe!
        if self.respond_to?(:nmap_probe)
          nmap_probe
        else
          probe
        end
      end

      def probe
        @result = @ports.reduce({}) do |acc, port|
          acc.merge(port => probe_port(port))
        end
      end

      private

      def arp_lookup
        # TODO
      end
    end

    class TCPProbe < Abstract
      def nmap_flags
        # Use TCP connect scan with service detection
        %w(-sT -sV)
      end
    end

    class UDPProbe < Abstract
      def nmap_flags
        # Use UDP scan with service detection
        %w(-sU -sV)
      end
    end

  end
end
