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
        ForemanProbingCore::Probes::TCP
      when 'udp'
        ForemanProbingCore::Probes::UDP
      when 'icmp'
        ForemanProbingCore::Probes::ICMP
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
        ::ForemanProbingCore::Targeting::Direct.new(params[:direct][:ip])
      when 'subnet'
        ::ForemanProbingCore::Targeting::Subnet.new(params[:subnet][:id])
      when 'host'
        ::ForemanProbingCore::Targeting::Host.new(params[:search_query])
      end
    end

  end
end
