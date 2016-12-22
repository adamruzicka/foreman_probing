module ForemanProbingCore
  module ServiceProbes

    class SSH < TCPProbe

      COMMON_PORTS = [22]

      # RFC4253, section 4.2: Protocol Version Exchange
      # https://tools.ietf.org/html/rfc4253
      IDENT_STRING_REGEXP = /^SSH-(.*?)-(.*?)( (.*))?\r\n/

      def probe_port(port)
        with_open_socket(port) do
          socket.close_write
          response = socket.read
          @result_builder.host_state('up')
          if is_ssh?(response)
            @result_builder.port_state('tcp', port, 'up', 'ssh', parse_response(response))
          else
            @result_builder.port_state('tcp', port, 'up', 'N/A', :raw_response => response)
          end
          @result_builder
        end
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
        exception_result e
      end

      private

      def is_ssh?(response)
        response.lines.find { |line| line =~ IDENT_STRING_REGEXP }
      end

      def parse_response(response)
        response.lines.find { |line| line =~ IDENT_STRING_REGEXP }
        { :protocol => $1, :protocol_version => $2,
          :software_version => $3, :comments => $4 }
      end
    end

  end
end
