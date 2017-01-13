module ForemanProbing
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    # create or overwrite instance methods...
    def instance_method_name
    end

    def probe_host(probe_class = ForemanProbingCore::ServiceProbes::TCPOpen)
    end


    module ClassMethods
      # create or overwrite class methods...
      def class_method_name
      end
    end
  end
end
