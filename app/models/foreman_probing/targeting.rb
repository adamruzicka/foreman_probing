module ForemanProbing
  module Targeting
    class Abstract

      # Returns array of strings, suitable for direct passing into nmap
      def targets
        raise NotImplementedError
      end
    end

    class Direct < Abstract

      # Either ip address or subnet in CIDR notation
      def initialize(address_string)
        @addresses = parse_address_string!(address_string)
      end

      def targets
        @addresses.map do |addr|
          str = ''
          case addr[:family].to_s
          when 'inet'
            str += addr[:addr]
            str += '/' + addr[:netmask] unless addr[:netmask].nil?
          when 'inet6'
            # TODO: ipv6
            raise NotImplementedError
          else
            raise ArgumentError, "Unknown address family #{addr[:family]}"
          end
          str
        end
      end

      private

      # TODO: Do some validation
      def parse_address_string!(str)
        if str.is_a?(Array)
          str.map { |item| parse_address_string! item }.flatten
        elsif str.is_a? Hash
          str
        else
          # TODO: Somehow use IPAddr
          str.split(',').map do |ip|
            if ip =~ /(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})(\/(\d{1,2}))?/
              { :family => :inet, :addr => $1, :netmask => $3 }
            else
              # TODO: Match ipv6 here
            end
          end
        end
      end
    end

    class Subnet < Abstract
      def initialize(subnet_id)
        @subnet = ::Subnet.authorized.find(subnet_id)
      end

      def targets
        # TODO: This is ugly
        cidr = IPAddr.new(@subnet.mask).to_i.to_s(2).count('1')
        @targets ||= "#{@subnet.network}/#{cidr}"
      end
    end

    class Host < Abstract
      def initialize(search_query, hosts = nil)
        @search_query = search_query
        @hosts = hosts
      end

      def targets
        @hosts ||= resolve_hosts!
        @targets ||= @hosts.map { |host| host.interfaces.map(&:ip) }.flatten
      end

      def resolve_hosts!
        # @hosts = Host.authorized(RESOLVE_PERMISSION, Host)
        #              .search_for(@search_query)
        @hosts = ::Host.authorized.search_for(@search_query)
      end
    end

    class SubnetDiscovery < Abstract
      def targets
        []
      end
    end
  end
end
