module ForemanProbing
  class Targeting < ActiveRecord::Base
    belongs_to :scan

    # Returns array of strings, suitable for direct passing into nmap
    def targets
      raise NotImplementedError
    end
  end
end
