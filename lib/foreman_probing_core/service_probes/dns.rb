require 'resolv'

module ForemanProbingCore
  module ServiceProbes

    class DNS < UDPProbe

      COMMON_PORTS = [53]

      def probe_port(port)
        resolver = Resolv::DNS.new(:nameserver => @host,
                                   :nameserver_port => [[@host, port]],
                                   :search => [],
                                   :ndots => 1)
        resolver.timeouts = @options.fetch(:timeout, 5)
        result = resolver.getname(@options.fetch(:target, '127.0.0.1'))
        @result_builder.host_state('up')
                       .port_state('udp', port, 'open', 'dns')
                       .result
      rescue Resolv::ResolvError => e
        @result_builder.exception(e).result
      end

    end
  end
end
