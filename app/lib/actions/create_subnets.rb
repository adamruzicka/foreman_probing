module Actions
  module ForemanProbing
    class CreateSubnets < Actions::EntryAction

      def run
        proxy = SmartProxy.find(input[:proxy_id])
        output[:subnet_ids] = []
        output[:subnets] = input[:scan][:proxy_output][:local_addresses].each do |str, hash|
          network_addr = IPAddr.new(hash[:addr]).mask(hash[:cidr]).to_s
          subnet = Subnet.where(:network => network_addr, :mask => hash[:netmask]).first
          if subnet.nil?
            subnet = Subnet.new
            subnet.network = network_addr
            subnet.mask = hash[:netmask]
            subnet.name = "#{str} at #{proxy.name}"
            subnet.save!
          else
            proxy.subnets << subnet
            proxy.save!
          end
          subnet.id
        end
      end
      
    end
  end
end
