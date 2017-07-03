module Actions
  module ForemanProbing
    class CreateSubnets < Actions::EntryAction
      middleware.use Actions::Middleware::KeepCurrentUser
      def run
        proxy = SmartProxy.find(input[:proxy_id])
        output[:subnet_ids] = input[:scan][:proxy_output][:local_addresses].map do |str, hash|
          network_addr = IPAddr.new(hash[:addr]).mask(hash[:cidr]).to_s
          subnet = Subnet.where(:network => network_addr, :mask => hash[:netmask]).first
          if subnet.nil?
            subnet = Subnet.new
            subnet.network = network_addr
            subnet.mask = hash[:netmask]
            subnet.name = "#{str} at #{proxy.name}"
            subnet.location_ids = proxy.location_ids
            subnet.organization_ids = proxy.organization_ids
            subnet.save!
          end
          proxy.subnets << subnet
          proxy.save!
          subnet.id
        end
      end
      
    end
  end
end
