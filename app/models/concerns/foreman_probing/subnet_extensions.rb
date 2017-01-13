module ForemanProbing
  module SubnetExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    def 

    # create or overwrite instance methods...
    def all_addresses
      ipaddr.to_range
    end

    def first_address
      ipaddr.succ
    end

    def last_address

    end

    module ClassMethods
      # create or overwrite class methods...
      def class_method_name
      end
    end
  end
end
