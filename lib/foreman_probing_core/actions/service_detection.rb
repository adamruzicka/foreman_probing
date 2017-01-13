module Actions
  module ForemanProbing
    class ServiceDetection

      def plan(targets, ports, service, options = {})
        use_nmap = options.delete(:use_nmap) || false
        @logger.warn(_('Requested nmap scan but nmap is not available, falling back to pure ruby.'))
        plan_self(:targets => targets,
                  :ports => ports,
                  :service => service_class(service).to_s,
                  :options => options)
      end

      def run
        output[:result] = input[:targets].map do |target|
          probe = input[:service].constantize.new(target, ports, input[:options])
          probe.probe!
          probe.result
        end
      end

      # def finalize

      # end

      private

      def service_class(service)
        probes = ForemanProbingCore::ServiceProbes.select do |klass|
          klass.is_a? ForemanProbingCore::Helpers::ServiceProbeHelper
        end
        probes.find { |probe| probe.service_name == service.downcase }
      end
    end
  end
end