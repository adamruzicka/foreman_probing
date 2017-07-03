module ForemanProbing
  module ScansHelper
    def scan_task_buttons(scan)
      task = scan.task
      task_authorizer = Authorizer.new(User.current, :collection => [task])
      buttons = []
      buttons << link_to(_('Rerun'), rerun_foreman_probing_scan_path(scan), :class => 'btn btn-default', :title => _('Refresh this page'))
      buttons << link_to(_('Refresh'), {}, :class => 'btn btn-default', :title => _('Refresh this page'))
      # if authorized_for(hash_for_new_job_invocation_path)
      #   buttons << link_to(_('Rerun'), rerun_job_invocation_path(:id => job_invocation.id),
      #                      :class => 'btn btn-default',
      #                      :title => _('Rerun the job'))
      # end
      if authorized_for(:permission => :view_foreman_tasks, :auth_object => task, :authorizer => task_authorizer)
        buttons << link_to(_('Task'), foreman_tasks_task_path(task),
                           :class => 'btn btn-default',
                           :title => _('See the task details'))
      end
      if authorized_for(:permission => :edit_foreman_tasks, :auth_object => task, :authorizer => task_authorizer)
        buttons << link_to(_('Cancel Task'), cancel_foreman_tasks_task_path(task),
                           :class => 'btn btn-danger',
                           :title => _('Try to cancel the task'),
                           :disabled => !task.cancellable?,
                           :method => :post)
      end
      return buttons
    end

    def targeting_label(targeting)
      case targeting
      when ::ForemanProbing::Targeting::Search
        "with search query '#{targeting.raw_targets}'"
      when ::ForemanProbing::Targeting::Direct
        "direct '#{targeting.raw_targets}'"
      when ::ForemanProbing::Targeting::SubnetDiscovery
        'subnet discovery'
      when ::ForemanProbing::Targeting::Subnet
        "subnet #{targeting.subnet.name}"
      end
    end
  end
end
