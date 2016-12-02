module ForemanProbingCore
  module ServiceProbes

    class Abstract

      COMMON_PORTS = []

      def initialize(host, ports = COMMON_PORTS, options = {})
        @host    = host
        @ports   = ports
        @options = options
      end

      def probe!
        @ports.reduce({}) do |acc, port|
          acc.merge(port => probe_port(port))
        end
      end

      private

      def exception_result(exception)
        { :state => :exception,
          :exception => {
            :class     => exception.class,
            :message   => exception.message,
            :backtrace => exception.backtrace }
        }
      end

      def valid_result(data = {})
        { :state => :valid, :meta => data } 
      end

      def invalid_result(data = {})
        { :state => :invalid, :meta => data }
      end

      def socket_data(socket)
        { :addr => socket.addr, :peeraddr => socket.peeraddr }
      end
      
    end

  end
end
