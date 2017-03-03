module ForemanProbing
  class ScanComposer

    attr_accessor :targeting, :ports, :probe

    def self.scan_from_params(params)
      self.new.tap do |c|
        c.targeting = c.targeting_from_params(params)
        c.ports = c.ports_from_params(params)
        c.probe = c.probe_from_params(params)
      end
    end

    def probe_from_params(params)
      case params[:scan_type].downcase
    when 'tcp'
        ForemanProbingCore::Probes::TCPProbe
        # case params[:tcp][:scan_options]
        # when 'detect'
        #   ForemanProbingCore::ServiceProbes::ALL_PROBES.find do |probe|
        #     probe.scan_type == 'tcp' &&
        #       probe.service_name == params[:tcp][:service].downcase
        #   end
        # when 'discover'
        #   ForemanProbingCore::ServiceProbes::TCPDiscover
        # when 'open'
        #   ForemanProbingCore::ServiceProbes::TCPOpen
        # end
      when 'udp'
        raise NotImplementedError
      when 'icmp'
        raise NotImplementedError
      end
    end

    def ports_from_params(params)
      ranges = params[:ports].split(',')
      ports = ranges.map do |range|
        range.split('-').map do |from, to|
          to.nil? ? from : (from..to).entries
        end
      end
      ports.flatten.map(&:chomp).map(&:to_i)
    end

    def targeting_from_params(params)
      case params[:target_kind].downcase
      when 'direct'
        ::ForemanProbing::Targeting::Direct.new.tap do |t|
          t.ip = params[:direct][:ip]
          t.netmask = params[:direct][:netmask]
        end
      when 'subnet'
        ::ForemanProbing::SubnetTargeting.new.tap do |t|
          t.subnet_id = params[:subnet][:id]
        end
      when 'host'
        ::ForemanProbing::HostTargeting.new.tap do |t|
          t.search_query = params['search_query']
          t.resolve_hosts!
        end
      end
    end

  end
end
