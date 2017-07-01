module ForemanProbing
  class Targeting::Subnet < Targeting
    # def initialize(subnet_id)
    #   @subnet = ::Subnet.authorized.find(subnet_id)
    # end

    def targets
      # TODO: This is ugly
      @subnet ||= ::Subnet.authorized.find(raw_targets.to_i)
      cidr = IPAddr.new(@subnet.mask).to_i.to_s(2).count('1')
      @targets ||= "#{@subnet.network}/#{cidr}"
    end
  end
end
