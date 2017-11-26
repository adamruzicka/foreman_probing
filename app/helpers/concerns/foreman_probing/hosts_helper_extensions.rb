module ForemanProbing
  module HostsHelperExtensions
    def host_title_actions(*args)
      title_actions(button_group(link_to(_('Probe'), new_foreman_probing_scan_path(:search_query => "name = #{args.first.name}", :target_kind => 'host'), :id => :run_button, :class => 'btn btn-default')))

      super(*args)
    end
  end
end
