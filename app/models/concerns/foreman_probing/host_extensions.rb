module ForemanProbing
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_many :scan_hosts, :class_name => '::ForemanProbing::ScanHost', :foreign_key => :host_id
      has_many :scans, :through => :scan_hosts, :class_name => '::ForemanProbing::Scan'
    end

    # create or overwrite instance methods...
    def instance_method_name
    end

    module ClassMethods
      # create or overwrite class methods...
      def class_method_name
      end
    end
  end
end
