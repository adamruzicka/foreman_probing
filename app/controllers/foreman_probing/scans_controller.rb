module ForemanProbing
  class ScansController < ::ApplicationController

    def new
      @scan = ForemanProbing::Scan.new
    end

    def create
      composer = ScanComposer.scan_from_params(params[:foreman_probing_scan])
      task = ForemanTasks.sync_task(::Actions::ForemanProbing::PerformScan,
                                    composer.targeting.targets.map(&:to_s),
                                    composer.probe,
                                    composer.ports
                                   )
      query = task.execution_plan.actions
                .map { |action| action.output[:hostname] }.compact
                .map { |hostname| "name = #{hostname}" }.join(' or ')
      redirect_to hosts_path(:search => query)
    end

  end
end
