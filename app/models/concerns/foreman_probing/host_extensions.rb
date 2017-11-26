module ForemanProbing
  module HostExtensions
    def self.prepended(base)
      base.instance_eval do
        has_many :scan_hosts, :class_name => '::ForemanProbing::ScanHost', :foreign_key => :host_id
        has_many :scans, :through => :scan_hosts, :class_name => '::ForemanProbing::Scan'
      end
    end
  end
end
