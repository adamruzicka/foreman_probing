module ForemanProbingCore
  module ServiceProbes

    class TCPOpen < TCPProbe

      COMMON_PORTS = [22, 80, 443]

      def probe_port(port)
        Socket.tcp(@host, port).close
        @result_builder.host_state('up').port_state('tcp', port, 'up')
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH => e
        exception_result(e)
      end

      def nmap_flags
        %w(-sT)
      end
    end

  end
end
