module ForemanProbing
  class Targeting::SubnetDiscovery < Targeting

    def target_kind
      'proxy'
    end

    def targets
      []
    end
  end
end
