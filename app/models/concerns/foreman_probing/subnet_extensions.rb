module ForemanProbing
  module SubnetExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
      has_many :probing_proxies, :dependent => :destroy
    end

    # create or overwrite instance methods...
    def probe!(probe)

    end

    module ClassMethods
      # create or overwrite class methods...
      def class_method_name
      end
    end
  end
end
