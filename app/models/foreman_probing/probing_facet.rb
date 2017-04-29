module ForemanProbing
  class ProbingFacet < ActiveRecord::Base
    include Facets::Base
    
    def self.table_name
      'foreman_probing_probing_facets'
    end

    validates :host, :presence => true, :allow_blank => false

    has_many :scanned_ports, :class_name => 'Port'
    has_many :services, :through => :scanned_ports

    def online?

    end

    def refresh

    end

    def ping!

    end

  end
end
