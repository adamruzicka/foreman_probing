require 'open3'

module ForemanProbingCore
  module ServiceProbes

    class Ping < Abstract

      COMMON_PORTS = []

      def initialize(host, options = {})
        super(host, [], options)
        @host    = host
        @count   = options.fetch(:count, 4)
        @options = options
      end

      def probe
        command = ['ping', '-c', @count.to_s, @host]
        result = nil
        status = nil
        Open3.popen3(*command) do |_stdin, stdout, stderr, wait_thr|
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

      def nmap_flags
        %w(-sn)
      end

      def parse_result(result)
        statistics = result.find { |line| line =~ /^\d+ packets transmitted/ }
      end

      def parse_error(result)
        result.shift
        # result.shift.match(/^PING (.*) \((.*?)\) (\d+)\((\d+)\)/)
        # There's some data in $1, $2, $3, $3
        pings = result.take_while { |line| line != "\n" }
      end
      
    end

  end
end
