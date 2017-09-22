module ForemanProbing
  class Targeting::Subnet < ForemanProbing::Targeting
    def target_kind
      'subnet'
    end

    def subnet
      @subnet ||= ::Subnet.authorized.find(raw_targets.to_i)
    end

    def targets
      # TODO: This is ugly
      cidr = IPAddr.new(subnet.mask).to_i.to_s(2).count('1')
      @targets ||= "#{subnet.network}/#{cidr}"
    end
  end
end
