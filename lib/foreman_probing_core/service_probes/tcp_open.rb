module ForemanProbingCore
  module ServiceProbes

    class TCPOpen < Abstract

      COMMON_PORTS = [22, 80, 443]

      def probe_port(port)
        Socket.tcp(@host, port).close
        valid_result
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH => e
        exception_result(e)
      end
    end

  end
end
