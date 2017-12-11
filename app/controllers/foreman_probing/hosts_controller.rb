module ForemanProbing
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    before_action :find_resource, :only => :open_ports

    def open_ports
      render :partial => 'open_ports'
    end

    private

    define_action_permission ['open_ports'], :view
  end
end
