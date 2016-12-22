require 'ipaddr'

module ForemanProbingCore
  module ServiceProbes

    class ResultBuilder

      attr_reader :result

      def initialize(host)
        @host = host
        @result = {
          :address => [],
          :status => {}, 
          :hostnames => [],
          :ports => [],
          :exceptions => []
        }
        address(host.to_s, host.ipv4? ? 'ipv4' : 'ipv6')
      end

      def exception(exception)
        exception = {
          :class     => exception.class,
          :message   => exception.message,
          :backtrace => exception.backtrace
        }
        add_if_missing(:exceptions, exception)
        self
      end

      def address(addr, type, base = {})
        entry = base.merge({ :addr => addr, :addrtype => type })
        add_if_missing(:address, entry)
        self
      end

      def state(state, reason = 'probe', base = {})
        @result[:status].update(base.merge(:state => state, :reason => reason))
        self
      end

      def port(protocol, number, state, service = nil, state_opt = {}, service_opt = {})
        data = {
          :protocol => protocol,
          :portid => number,
          :state => state_opt.merge({ :state => state })
        }
        data.update(:service => service_opt.merge({ :name => service })) if service
        add_if_missing(:ports, data)
        self
      end

      def hostname(hostname)
        add_if_missing(:hostnames, hostname)
        self
      end

      private

      def add_if_missing(kind, entry)
        @result[kind] << entry unless @result[kind].include?(entry)
      end
    end

    class Abstract

      include ForemanProbingCore::Helpers::NmapHelper

      COMMON_PORTS = []

      attr_reader :result_builder

      def initialize(host, ports = COMMON_PORTS, options = {})
        @host    = IPAddr.new(host)
        @ports   = ports
        @options = options
        @result_builder = ResultBuilder.new(@host)
      end

      def probe!
        if self.respond_to?(:nmap_probe)
          nmap_probe
        else
          probe
          arp_lookup if @host.ipv4?
          @result_builder.result
        end
      end

      def probe
        @result = @ports.reduce({}) do |acc, port|
          acc.merge(port => probe_port(port))
        end
      end

      private

      def exception_result(exception)
        @result_builder.exception(exception)
      end

      def arp_lookup
        records = `arp #{@host}`.lines.drop(1) # Drop the header
        records.each do |record|
          ip, _hwtype, hwaddr, _flags, _iface = record.split(' ')
          result_builder.address(hwaddr, 'mac')
          result_builder.hostname(ip) if ip != @host.to_s
        end
      end
    end

    class TCPProbe < Abstract
      def nmap_flags
        # Use TCP connect scan with service detection
        %w(-sT -sV)
      end

      def with_open_socket(port)
        Socket.tcp(@host.to_s, port) do |socket|
          yield socket if block_given?
        end
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
