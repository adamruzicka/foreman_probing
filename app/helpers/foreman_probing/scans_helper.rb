module ForemanProbing
  module ScansHelper
    def scan_task_buttons(task)
      task_authorizer = Authorizer.new(User.current, :collection => [task])
      buttons = []
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
  end
end
