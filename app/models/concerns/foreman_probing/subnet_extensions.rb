module ForemanProbing
  module SubnetExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    def 

    # create or overwrite instance methods...
    def all_addresses
      network = ipaddr
      results = []
      addr = ipaddr.succ
      while network.include? addr
        results << addr
        addr = addr.succ
      end
      results
    end

    module ClassMethods
      # create or overwrite class methods...
      def class_method_name
      end
    end
  end
end
