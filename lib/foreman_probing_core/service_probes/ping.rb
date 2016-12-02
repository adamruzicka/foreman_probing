require 'open3'

module ForemanProbingCore
  module ServiceProbes

    class Ping

      COMMON_PORTS = []

      def initialize(host, options = {})
        @host    = host
        @options = options
      end

      def probe!
        count = @options.fetch(:count, 4).to_i
        command = ['ping', '-c', count.to_s, @host]
        result = nil
        status = nil
        Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
          wait_thr.join
          result = stdout.readlines
          status = wait_thr.value
        end
        if status.success?
          parse_result(result)
        else
          parse_error(result)
        end
      end

      private

      def parse_result(result)
        statistics = result.find { |line| line =~ /^\d+ packets transmitted/ }
        
      end

      def parse_error(result)
        result.shift
        # result.shift.match(/^PING (.*) \((.*?)\) (\d+)\((\d+)\)/)
        # There's some data in $1, $2, $3, $3
        pings = result.take_while { |line| line != "\n" }
      end

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
