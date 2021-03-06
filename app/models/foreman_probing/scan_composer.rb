module ForemanProbing
  class ScanComposer

    attr_accessor :targeting, :ports, :probe, :proxy

    TARGETING_TYPES = %w(direct subnet host proxy).freeze

    def self.new_from_params(params)
      self.new.tap do |c|
        c.targeting = c.targeting_from_params(params)
        c.ports = c.ports_from_params(params)
        c.probe = params[:scan_type]
        c.proxy = c.proxy_from_params(params)
      end
    end

    def self.new_from_scan(scan)
      self.new.tap do |c|
        c.targeting = scan.targeting.dup
        c.ports = scan.raw_ports
        c.probe = scan.scan_type
        c.proxy = scan.smart_proxy
      end
    end

    def compose!
      if @scan.nil?
        @scan = ForemanProbing::Scan.new
        @scan.targeting = targeting
        @scan.target_kind = targeting.target_kind
        @scan.smart_proxy = proxy
        @scan.scan_type = probe
        @scan.raw_ports = ports

        case targeting
        when ::ForemanProbing::Targeting::Direct
          @scan.direct = targeting.raw_targets
        when ::ForemanProbing::Targeting::Subnet
          @scan.subnet_id = targeting.raw_targets.to_i
        when ::ForemanProbing::Targeting::Search
          @scan.search_query = targeting.raw_targets
        end
      end
      @scan
    end

    def proxy_from_params(params)
      SmartProxy.authorized.find(params['smart_proxy_id'])
    end

    def ports_from_params(params)
      # ranges = params[:ports].split(',')
      # ports = ranges.map do |range|
      #   range.split('-').map do |from, to|
      #     to.nil? ? from : (from..to).entries
      #   end
      # end
      # ports.flatten.map(&:chomp).map(&:to_i)
      params[:raw_ports]
    end

    def targeting_from_params(params)
      case params[:target_kind].downcase
      when 'direct'
        ::ForemanProbing::Targeting::Direct.new(:raw_targets => params[:direct])
      when 'subnet'
        ::ForemanProbing::Targeting::Subnet.new(:raw_targets => params[:subnet_id])
      when 'host'
        ::ForemanProbing::Targeting::Search.new(:raw_targets => params[:search_query])
      when 'proxy'
        ::ForemanProbing::Targeting::SubnetDiscovery.new
      end
    end
  end
end
