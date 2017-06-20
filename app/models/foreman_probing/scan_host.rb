module ForemanProbing
  class ScanHost < ActiveRecord::Base

    belongs_to :scan
    belongs_to :host
    
  end
end
