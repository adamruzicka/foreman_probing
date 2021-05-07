module Actions
  module ForemanProbing
    class ScanHost < Actions::EntryAction
      middleware.use Actions::Middleware::KeepCurrentUser
      include ::Actions::Helpers::WithDelegatedAction

      middleware.do_not_use Dynflow::Middleware::Common::Transaction

      def plan(host, probes, proxy_selector = ::ForemanProbingProxySelector.new, port_overrides = {})
        action_subject(host, :probes => probes.map(&:to_s))

        hostname = find_ip_or_hostname(host)
        proxy = proxy_selector.determine_proxy(host)
        plan_delegated_action(proxy, 'ForemanProbingCore::Actions::UseProbe', hostname, probes, port_overrides)
        plan_self
      end

      private
      
      def find_ip_or_hostname(host)
        %w(execution primary provision).each do |flag|
          interface = host.send(flag + '_interface')
          return interface.ip if interface && interface.ip.present?
        end

        host.interfaces.each do |interface|
          return interface.ip unless interface.ip.blank?
        end

        return host.fqdn
      end
      
    end
  end
end
