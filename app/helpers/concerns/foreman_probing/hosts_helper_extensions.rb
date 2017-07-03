module ForemanProbing
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
      alias_method_chain(:host_title_actions, :probe_button)
      # alias_method_chain :multiple_actions, :probing
    end

    # def multiple_actions_with_probing(*args)
    #   require 'pry'; binding.pry
    #   multiple_actions_without_probing + [[_('Probe'), new_foreman_probing_scan_path, true]]
    # end

    def host_title_actions_with_probe_button(*args)
      title_actions(button_group(link_to(_('Probe'), new_foreman_probing_scan_path(:search_query => "name = #{args.first.name}", :target_kind => 'host'), :id => :run_button, :class => 'btn btn-default')))

      host_title_actions_without_probe_button(*args)
    end
  end
end
