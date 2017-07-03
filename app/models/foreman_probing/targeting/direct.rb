module ForemanProbing
  class Targeting::Direct < Targeting

    # Either ip address or subnet in CIDR notation
    # def initialize(address_string)
    #   @addresses = parse_address_string!(address_string)
    # end

    def targets
      parse_address_string!(raw_targets).map do |addr|
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

    def target_kind
      'direct'
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
end
