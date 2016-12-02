module ForemanProbingCore
  module ServiceProbes

    class HTTP < Abstract

      COMMON_PORTS = [80]

      def probe_port(port)
        with_open_socket(port) do |socket|
          socket.print(head_data)
          socket.close_write
          response = socket.read
          result = parse_response(response)
          result.merge(socket_data(socker))
        end
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
        exception_result(e)
      end

      private

      def with_open_socket(port)
        Socket.tcp(@host, port) do |socket|
          yield socket
        end
      end

      def parse_response(response)
        lines = response.lines
        protocol, code, status = lines.shift.split(' ', 3)
        return invalid_response(response) unless protocol =~ /^HTTP/

        headers = lines.map { |line| line.split(': ', 2) }.reduce({}) do |acc, cur|
          acc.merge(cur.first => cur.last)
        end
        valid_result(:protocol => protocol, :http_code => code,
                     :http_status => status, :headers => headers)
      end

      def head_data
        <<-END.gsub(/^.*\| /, '').gsub("\n", "\r\n")
          | HEAD / HTTP/1.1
          | Host: #{@host}
          END
      end
      
    end

    class HTTPS < HTTP

      COMMON_PORTS = [443]

      private

      def with_open_socket(port)
        super(port) do |socket|
          ssl_context = OpenSSL::SSL::SSLContext.new
          ssl_context.set_params(:verify_mode => OpenSSL::SSL::VERIFY_PEER)
          ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
          ssl_socket.connect
          yield ssl_socket
          ssl_socket.close
        end
      end

      def socket_data(socket)
        ssl_data = { :cipher => socket.cipher,
                     :peer_cert => socket.peer_cert,
                     :peer_cert_chain => socket.peer_cert_chain,
                     :ssl_version => socket.ssl_version }
        super(socket.io).merge(:ssl => ssl_data)
      end
      
    end

  end
end
