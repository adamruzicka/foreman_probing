module ForemanProbingCore
  module ServiceProbes

    class SSH < Abstract

      COMMON_PORTS = [22]

      # RFC4253, section 4.2: Protocol Version Exchange
      # https://tools.ietf.org/html/rfc4253
      IDENT_STRING_REGEXP = /^SSH-(.*?)-(.*?)( (.*))?\r\n/

      def probe_port(port)
        Socket.tcp(@host, port) do |socket|
          socket.close_write
          response = socket.read
          parse_response(response)
        end
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
        exception_result(e)
      end

      private

      def parse_response(response)
        server_version = response.lines.find { |line| line =~ IDENT_STRING_REGEXP }
        return invalid_response(response) if server_version.nil?
        valid_result(:protocol => $1, :protocol_version => $2,
                     :software_version => $3, :comments => $4)
      end
    end

  end
end
