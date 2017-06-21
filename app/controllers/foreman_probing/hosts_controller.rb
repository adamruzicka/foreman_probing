module ForemanProbing
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    # change layout if needed
    # layout 'foreman_probing/layouts/new_layout'
    before_action :find_resource, :only => :open_ports

    def new_action
      # automatically renders view/foreman_probing/hosts/new_action
    end

    def open_ports
      render :partial => 'open_ports'
    end

    private

    define_action_permission ['open_ports'], :view
  end
end
