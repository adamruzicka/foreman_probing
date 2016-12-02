require 'resolv'

module ForemanProbingCore
  module ServiceProbes

    class DNS < Abstract

      COMMON_PORTS = [53]

      def probe_port(port)
        resolver = Resolv::DNS.new(:nameserver => @host,
                                   :nameserver_port => [[@host, port]],
                                   :search => [],
                                   :ndots => 1)
        resolver.timeouts = 1
        result = resolver.getname('127.0.0.1')
        valid_result(:port => port)
      rescue Resolv::ResolvError => e
        exception_result(e)
      end
    end
  end
end
