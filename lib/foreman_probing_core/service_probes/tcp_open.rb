module ForemanProbingCore
  module ServiceProbes

    class TCPOpen < TCPProbe

      COMMON_PORTS = [22, 80, 443]

      def probe_port(port)
        with_open_socket(port)
        @result_builder.host_state('up').port_state('tcp', port, 'open')
      rescue Errno::ECONNREFUSED => e
        @result_builder.host_state('up').port_state('tcp', port, 'filtered', :reason => reason)
                       .exception(e)
      rescue Errno::ETIMEDOUT, Errno::EHOSTUNREACH => e
        exception_result(e)
      end

      def reason
        'syn-ack'
      end

      def nmap_flags
        %w(-sT)
      end
    end

  end
end
