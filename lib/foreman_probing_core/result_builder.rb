module ForemanProbingCore
  class ResultBuilder

      attr_reader :result

      def initialize(host)
        @host = host
        @result = {
          :_type => :foreman_probing,
          :address => [],
          :status => {},
          :hostnames => [],
          :ports => [],
          :exceptions => []
        }
        address(host.to_s, host.ipv4? ? 'ipv4' : 'ipv6')
      end

      def exception(exception)
        exception = {
          :class     => exception.class,
          :message   => exception.message,
          :backtrace => exception.backtrace
        }
        add_if_missing(:exceptions, exception)
        self
      end

      def address(addr, type, base = {})
        entry = base.merge({ :addr => addr, :addrtype => type })
        add_if_missing(:address, entry)
        self
      end

      def state(state, reason = 'probe', base = {})
        @result[:status].update(base.merge(:state => state, :reason => reason))
        self
      end

      def port(protocol, number, state, service = nil, state_opt = {}, service_opt = {})
        data = {
          :protocol => protocol,
          :portid => number,
          :state => state_opt.merge({ :state => state })
        }
        data.update(:service => service_opt.merge({ :name => service })) if service
        add_if_missing(:ports, data)
        self
      end

      def hostname(hostname)
        add_if_missing(:hostnames, hostname)
        self
      end

      private

      def add_if_missing(kind, entry)
        @result[kind] << entry unless @result[kind].include?(entry)
      end
    end
  end
end
