module ForemanProbingCore
  module Helpers
    module ServiceProbeHelper

      def self.service_name
        self.to_s.downcase
      end

      def self.humanized_service_name
        self.to_s
      end

    end
  end
end
